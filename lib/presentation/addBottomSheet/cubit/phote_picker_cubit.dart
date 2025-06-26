import 'dart:convert';
import 'dart:io';
import 'package:drobee/data/services/firestore_database_service.dart';
import 'package:drobee/presentation/addBottomSheet/cubit/photo_picker_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:drobee/data/services/photo_picker_service.dart';

class PhotoPickerCubit extends Cubit<PhotoPickerState> {
  final String? currentUserId;

  PhotoPickerCubit({this.currentUserId}) : super(PhotoPickerState.initial());

  void toggleWeather(String weather) {
    final updated = [...state.selectedWeathers];
    updated.contains(weather) ? updated.remove(weather) : updated.add(weather);
    emit(state.copyWith(selectedWeathers: updated));
  }

  Future<void> pickImage(ImageSource source) async {
    if (state.hasAnyLoading) return;

    _resetStateBeforePickingImage();

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile == null) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      final selectedFile = File(pickedFile.path);
      emit(state.copyWith(selectedImage: selectedFile));

      emit(state.copyWith(isLoading: false, isProcessing: true));
      await _processPickedImage(selectedFile);
    } catch (e) {
      _showError('Resim seçme hatası: $e');
      emit(state.copyWith(isLoading: false, isProcessing: false));
    }
  }

  void removeImage() {
    emit(
      state.copyWith(
        removeSelectedImage: true,
        removeProcessedImage: true,
        removeUploadedImageUrl: true,
        selectedWeathers: [],
      ),
    );
  }

  Future<String?> uploadToFreeImageHost() async {
    if (state.displayImage == null || state.isUploading) return null;

    emit(state.copyWith(isUploading: true, error: null));

    try {
      final bytes = await state.displayImage!.readAsBytes();
      final base64Image = base64Encode(bytes);

      final request =
          http.MultipartRequest(
              'POST',
              Uri.parse('https://freeimage.host/api/1/upload'),
            )
            ..fields['key'] = '6d207e02198a847aa98d0a2a901485a5'
            ..fields['format'] = 'json'
            ..fields['source'] = base64Image;

      final response = await request.send();
      final body = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final decoded = json.decode(body);
        final imageUrl = decoded['image']?['url'];
        if (imageUrl != null && imageUrl.toString().startsWith('http')) {
          emit(state.copyWith(uploadedImageUrl: imageUrl));
          return imageUrl;
        }
        _showError('Yüklenen resim linki alınamadı.');
      } else {
        _showError('Sunucu hatası: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Yükleme hatası: $e');
    } finally {
      emit(state.copyWith(isUploading: false));
    }

    return null;
  }

  void clearMessages() =>
      emit(state.copyWith(error: null, successMessage: null));
  void setSuccessMessage(String msg) =>
      emit(state.copyWith(successMessage: msg));
  void setErrorMessage(String msg) => emit(state.copyWith(error: msg));
  void reset() => emit(PhotoPickerState.initial());

  Future<void> savePhotoWithWeathers() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (state.displayImage == null) {
      return setErrorMessage('Lütfen bir fotoğraf seçin');
    }
    if (state.selectedWeathers.isEmpty) {
      return setErrorMessage('Lütfen en az bir hava durumu seçin');
    }

    try {
      final imageUrl = await uploadToFreeImageHost();
      if (imageUrl != null) {
        await FirestoreService.saveUserPhoto(
          userId: uid!,
          imageUrl: imageUrl,
          weatherTags: state.selectedWeathers,
        );

        setSuccessMessage('Fotoğraf başarıyla yüklendi ve kaydedildi!');
        emit(
          state.copyWith(
            selectedImage: null,
            processedImage: null,
            selectedWeathers: [],
            uploadedImageUrl: null,
          ),
        );
      } else {
        setErrorMessage('Resim yükleme başarısız');
      }
    } catch (e) {
      setErrorMessage('Kaydetme hatası: $e');
    }
  }

  Future<void> handleSave(
    Function(String) onSuccess,
    Function(String) onError,
  ) async {
    if (state.displayImage == null) {
      return onError('Lütfen bir fotoğraf seçin.');
    }
    if (state.selectedWeathers.isEmpty) {
      return onError('Lütfen en az bir hava durumu seçin.');
    }

    try {
      final imageUrl = await uploadToFreeImageHost();
      if (imageUrl != null) {
        onSuccess(imageUrl);
        emit(
          state.copyWith(
            selectedImage: null,
            processedImage: null,
            selectedWeathers: [],
          ),
        );
      } else {
        onError('Resim yükleme başarısız oldu.');
      }
    } catch (e) {
      onError('Beklenmeyen hata: $e');
    }
  }

  void _resetStateBeforePickingImage() {
    emit(
      state.copyWith(
        isLoading: true,
        selectedImage: null,
        processedImage: null,
        selectedWeathers: [],
        uploadedImageUrl: null,
        error: null,
      ),
    );
  }

  Future<void> _processPickedImage(File image) async {
    final processed = await PhotoPickerService.removeBackgroundFromFile(image);
    if (processed != null) {
      emit(state.copyWith(processedImage: processed, isProcessing: false));
    } else {
      emit(
        state.copyWith(
          processedImage: image,
          isProcessing: false,
          error:
              'Arka plan silme işlemi başarısız, orijinal resim kullanılacak',
        ),
      );
    }
  }

  void _showError(String msg) => emit(state.copyWith(error: msg));
}
