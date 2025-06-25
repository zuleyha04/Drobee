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
    if (updated.contains(weather)) {
      updated.remove(weather);
    } else {
      updated.add(weather);
    }
    emit(state.copyWith(selectedWeathers: updated));
  }

  Future<void> pickImage(ImageSource source) async {
    if (state.hasAnyLoading) return;

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

      final processedImage =
          await PhotoPickerService.pickImageWithBackgroundRemoval(source);

      if (processedImage != null) {
        emit(
          state.copyWith(processedImage: processedImage, isProcessing: false),
        );
      } else {
        emit(
          state.copyWith(
            processedImage: selectedFile,
            isProcessing: false,
            error:
                'Arka plan silme işlemi başarısız, orijinal resim kullanılacak',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isProcessing: false,
          error: 'Resim seçme hatası: $e',
        ),
      );
    }
  }

  void removeImage() {
    emit(
      state.copyWith(
        selectedImage: null,
        processedImage: null,
        uploadedImageUrl: null,
      ),
    );
  }

  Future<String?> uploadToFreeImageHost() async {
    if (state.displayImage == null || state.isUploading) return null;

    emit(state.copyWith(isUploading: true, error: null));

    try {
      final bytes = await state.displayImage!.readAsBytes();

      // Byte dizisini base64 formatına çevir
      final base64Image = base64Encode(bytes);

      final uri = Uri.parse('https://freeimage.host/api/1/upload');
      final request =
          http.MultipartRequest('POST', uri)
            ..fields['key'] = '6d207e02198a847aa98d0a2a901485a5'
            ..fields['format'] = 'json'
            ..fields['source'] = base64Image;

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();

        print('Response body: $responseBody');
        final decoded = json.decode(responseBody);
        final imageUrl = decoded['image']?['url'];

        if (imageUrl != null && imageUrl.toString().startsWith('http')) {
          emit(state.copyWith(uploadedImageUrl: imageUrl));
          return imageUrl;
        } else {
          emit(state.copyWith(error: 'Yüklenen resim linki alınamadı.'));
          return null;
        }
      } else {
        emit(state.copyWith(error: 'Sunucu hatası: ${response.statusCode}'));
        return null;
      }
    } catch (e) {
      emit(state.copyWith(error: 'Yükleme hatası: $e'));
      return null;
    } finally {
      emit(state.copyWith(isUploading: false));
    }
  }

  // Hata ve başarı mesajlarını temizle
  void clearMessages() {
    emit(state.copyWith(error: null, successMessage: null));
  }

  // Başarı mesajı set et
  void setSuccessMessage(String message) {
    emit(state.copyWith(successMessage: message));
  }

  // Hata mesajı set et
  void setErrorMessage(String message) {
    emit(state.copyWith(error: message));
  }

  // Tüm seçimleri sıfırla
  void reset() {
    emit(PhotoPickerState.initial());
  }

  // Ana kaydetme fonksiyonu
  Future<void> savePhotoWithWeathers() async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    if (state.displayImage == null) {
      setErrorMessage('Lütfen bir fotoğraf seçin');
      return;
    }

    if (state.selectedWeathers.isEmpty) {
      setErrorMessage('Lütfen en az bir hava durumu seçin');
      return;
    }

    if (currentUserId == null) {
      setErrorMessage('Kullanıcı girişi gerekli');
      return;
    }

    try {
      // FreeImage.host'a yükle
      final imageUrl = await uploadToFreeImageHost();

      if (imageUrl != null) {
        await FirestoreService.saveUserPhoto(
          userId: currentUserId,
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
      onError('Lütfen bir fotoğraf seçin.');
      return;
    }

    if (state.selectedWeathers.isEmpty) {
      onError('Lütfen en az bir hava durumu seçin.');
      return;
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
}
