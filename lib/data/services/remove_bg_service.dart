import 'dart:io';
import 'dart:typed_data';
import 'package:drobee/common/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class RemoveBgService {
  static Future<File?> removeBackground(File imageFile) async {
    try {
      // File size check (Remove.bg 12MB limit)
      int fileSizeInBytes = await imageFile.length();
      if (fileSizeInBytes > 12 * 1024 * 1024) {
        throw Exception('File is too large (maximum 12MB)');
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.removeBgBaseUrl),
      );

      request.headers['X-Api-Key'] = ApiConstants.removeBgApiKey;
      request.files.add(
        await http.MultipartFile.fromPath('image_file', imageFile.path),
      );
      request.fields['size'] = 'auto';

      var response = await request.send();

      if (response.statusCode == 200) {
        Uint8List imageBytes = await response.stream.toBytes();

        // Create temporary file
        final Directory tempDir = await getTemporaryDirectory();
        final String tempPath =
            '${tempDir.path}/no_bg_${DateTime.now().millisecondsSinceEpoch}.png';
        final File processedFile = File(tempPath);
        await processedFile.writeAsBytes(imageBytes);

        return processedFile;
      } else if (response.statusCode == 402) {
        throw Exception('Your API limit has been reached');
      } else {
        throw Exception('Background removal error (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Remove.bg error: $e');
    }
  }
}
