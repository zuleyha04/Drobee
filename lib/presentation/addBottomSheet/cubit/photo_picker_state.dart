import 'dart:io';

class PhotoPickerState {
  final File? selectedImage;
  final File? processedImage; // Arka planı silinmiş resim
  final List<String> selectedWeathers;
  final bool isLoading; // Resim seçme/işleme loading
  final bool isUploading; // FreeImage.host'a yükleme loading
  final bool isProcessing; // Arka plan silme işlemi loading
  final String? error;
  final String? successMessage;
  final String? uploadedImageUrl; // FreeImage.host'tan dönen URL

  const PhotoPickerState({
    this.selectedImage,
    this.processedImage,
    this.selectedWeathers = const [],
    this.isLoading = false,
    this.isUploading = false,
    this.isProcessing = false,
    this.error,
    this.successMessage,
    this.uploadedImageUrl,
  });

  factory PhotoPickerState.initial() {
    return const PhotoPickerState();
  }

  PhotoPickerState copyWith({
    File? selectedImage,
    bool removeSelectedImage = false,

    File? processedImage,
    bool removeProcessedImage = false,

    List<String>? selectedWeathers,
    bool? isLoading,
    bool? isUploading,
    bool? isProcessing,
    String? error,
    String? successMessage,
    String? uploadedImageUrl,
    bool removeUploadedImageUrl = false,
  }) {
    return PhotoPickerState(
      selectedImage:
          removeSelectedImage ? null : selectedImage ?? this.selectedImage,
      processedImage:
          removeProcessedImage ? null : processedImage ?? this.processedImage,
      selectedWeathers: selectedWeathers ?? this.selectedWeathers,
      isLoading: isLoading ?? this.isLoading,
      isUploading: isUploading ?? this.isUploading,
      isProcessing: isProcessing ?? this.isProcessing,
      error: error,
      successMessage: successMessage,
      uploadedImageUrl:
          removeUploadedImageUrl
              ? null
              : uploadedImageUrl ?? this.uploadedImageUrl,
    );
  }

  // Herhangi bir loading durumu var mı kontrolü
  bool get hasAnyLoading => isLoading || isUploading || isProcessing;

  // Gösterilecek resim
  File? get displayImage => processedImage ?? selectedImage;
}
