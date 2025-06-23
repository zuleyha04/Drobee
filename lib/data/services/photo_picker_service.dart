import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'remove_bg_service.dart';

class PhotoPickerService {
  static Future<File?> pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      return pickedFile != null ? File(pickedFile.path) : null;
    } catch (e) {
      throw Exception('Fotoğraf seçilemedi: $e');
    }
  }

  static Future<File?> pickImageWithBackgroundRemoval(
    ImageSource source,
  ) async {
    try {
      final File? originalImage = await pickImage(source);
      if (originalImage == null) return null;

      final File? processedImage = await RemoveBgService.removeBackground(
        originalImage,
      );

      return processedImage;
    } catch (e) {
      throw Exception('Fotoğraf işleme hatası: $e');
    }
  }
}
