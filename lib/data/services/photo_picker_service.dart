import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'remove_bg_service.dart';

class PhotoPickerService {
  static Future<File?> pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      return pickedFile != null ? File(pickedFile.path) : null;
    } catch (e) {
      throw Exception('Failed to select photo: $e');
    }
  }

  static Future<File?> removeBackgroundFromFile(File originalImage) async {
    try {
      return await RemoveBgService.removeBackground(originalImage);
    } catch (e) {
      throw Exception('Photo processing error: $e');
    }
  }
}
