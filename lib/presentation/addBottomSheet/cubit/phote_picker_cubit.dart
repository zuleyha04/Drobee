import 'package:drobee/data/services/drive/drive_service.dart';
import 'package:drobee/presentation/addBottomSheet/cubit/photo_picker_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:drobee/data/services/photo_picker_service.dart';
import 'package:drobee/data/services/firebase_save_items.dart';
import 'package:path/path.dart' as path;

class PhotoPickerCubit extends Cubit<PhotoPickerState> {
  final GoogleDriveService _driveService;

  PhotoPickerCubit(this._driveService) : super(PhotoPickerState.initial());

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
    if (state.isLoading) return;
    emit(
      state.copyWith(
        isLoading: true,
        selectedImage: null,
        selectedWeathers: [],
      ),
    );

    try {
      final image = await PhotoPickerService.pickImageWithBackgroundRemoval(
        source,
      );
      if (image != null) {
        emit(state.copyWith(selectedImage: image));
      }
    } catch (e) {
      emit(state.copyWith(error: 'Hata: $e'));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  void removeImage() {
    emit(state.copyWith(selectedImage: null));
  }

  Future<String?> uploadToDrive() async {
    if (state.selectedImage == null || state.isUploading) return null;

    emit(state.copyWith(isUploading: true));

    try {
      final hasPermission = await _driveService.checkDrivePermission();
      if (!hasPermission) {
        final granted = await _driveService.requestDrivePermission();
        if (!granted) return null;
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = path.extension(state.selectedImage!.path);
      final fileName = 'background_removed_$timestamp$extension';

      final String? uploadedFileId =
          (await _driveService.uploadImageToDrive(
                state.selectedImage!,
                fileName,
              ))
              as String?;

      return uploadedFileId;
    } catch (e) {
      emit(state.copyWith(error: 'Yükleme hatası: $e'));
      return null;
    } finally {
      emit(state.copyWith(isUploading: false));
    }
  }

  Future<void> handleSave(
    Function(String) onSuccess,
    Function(String) onError,
  ) async {
    if (state.selectedImage == null) {
      onError('Lütfen bir fotoğraf seçin.');
      return;
    }

    if (!FirebasePhotoService.isUserLoggedIn()) {
      onError('Lütfen önce giriş yapın.');
      return;
    }

    final fileId = await uploadToDrive();
    if (fileId == null) return;

    final saveSuccess = await FirebasePhotoService.savePhotoToFirebase(
      imageId: fileId,
      weatherTags: state.selectedWeathers,
    );

    if (saveSuccess) {
      onSuccess(fileId);
      emit(state.copyWith(selectedImage: null, selectedWeathers: []));
    } else {
      onError('Fotoğraf kaydedilirken bir hata oluştu.');
    }
  }

  // YENİ EKLENEN FONKSİYONLAR

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

  // Save işlemini UI callback'leri ile yönet
  Future<void> savePhotoWithWeathers() async {
    if (state.selectedImage == null) {
      setErrorMessage('Lütfen bir fotoğraf seçin');
      return;
    }

    if (state.selectedWeathers.isEmpty) {
      setErrorMessage('Lütfen en az bir hava durumu seçin');
      return;
    }

    if (!FirebasePhotoService.isUserLoggedIn()) {
      setErrorMessage('Lütfen önce giriş yapın');
      return;
    }

    // Loading durumunu set et
    emit(state.copyWith(isUploading: true, error: null));

    try {
      final fileId = await uploadToDrive();

      if (fileId == null) {
        setErrorMessage('Drive yükleme başarısız');
        return;
      }

      final saveSuccess = await FirebasePhotoService.savePhotoToFirebase(
        imageId: fileId,
        weatherTags: state.selectedWeathers,
      );

      if (saveSuccess) {
        setSuccessMessage(
          'Fotoğraf ve hava durumu bilgileri başarıyla kaydedildi!',
        );
        // Seçimleri temizle
        emit(
          state.copyWith(
            selectedImage: null,
            selectedWeathers: [],
            isUploading: false,
          ),
        );
      } else {
        setErrorMessage('Firebase kaydetme hatası oluştu');
      }
    } catch (e) {
      setErrorMessage('Beklenmeyen hata: $e');
    } finally {
      emit(state.copyWith(isUploading: false));
    }
  }
}
