import 'dart:io';

class PhotoPickerState {
  final File? selectedImage;
  final bool isLoading;
  final bool isUploading;
  final List<String> selectedWeathers;
  final String? error;

  PhotoPickerState({
    required this.selectedImage,
    required this.isLoading,
    required this.isUploading,
    required this.selectedWeathers,
    this.error,
  });

  factory PhotoPickerState.initial() => PhotoPickerState(
    selectedImage: null,
    isLoading: false,
    isUploading: false,
    selectedWeathers: [],
  );

  PhotoPickerState copyWith({
    File? selectedImage,
    bool? isLoading,
    bool? isUploading,
    List<String>? selectedWeathers,
    String? error,
  }) {
    return PhotoPickerState(
      selectedImage: selectedImage ?? this.selectedImage,
      isLoading: isLoading ?? this.isLoading,
      isUploading: isUploading ?? this.isUploading,
      selectedWeathers: selectedWeathers ?? this.selectedWeathers,
      error: error,
    );
  }
}
