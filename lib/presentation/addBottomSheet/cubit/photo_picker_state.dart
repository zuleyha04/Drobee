import 'dart:io';

class PhotoPickerState {
  final File? selectedImage;
  final List<String> selectedWeathers;
  final bool isLoading;
  final bool isUploading;
  final String? error;
  final String? successMessage; // YENİ EKLENEN ALAN

  const PhotoPickerState({
    this.selectedImage,
    this.selectedWeathers = const [],
    this.isLoading = false,
    this.isUploading = false,
    this.error,
    this.successMessage, // YENİ EKLENEN ALAN
  });

  factory PhotoPickerState.initial() {
    return const PhotoPickerState();
  }

  PhotoPickerState copyWith({
    File? selectedImage,
    List<String>? selectedWeathers,
    bool? isLoading,
    bool? isUploading,
    String? error,
    String? successMessage, // YENİ EKLENEN ALAN
  }) {
    return PhotoPickerState(
      selectedImage: selectedImage ?? this.selectedImage,
      selectedWeathers: selectedWeathers ?? this.selectedWeathers,
      isLoading: isLoading ?? this.isLoading,
      isUploading: isUploading ?? this.isUploading,
      error: error,
      successMessage: successMessage, // YENİ EKLENEN ALAN
    );
  }
}
