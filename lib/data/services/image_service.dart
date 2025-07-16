import 'dart:io';
import 'dart:typed_data';
import 'package:drobee/common/constants/api_constants.dart';
import 'package:drobee/data/services/remote_config_service.dart';
import 'package:drobee/core/utils/app_flushbar.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class RemoveBgService {
  static Future<File?> removeBackground(
    File imageFile,
    BuildContext context,
  ) async {
    try {
      int fileSizeInBytes = await imageFile.length();
      if (fileSizeInBytes > 12 * 1024 * 1024) {
        AppFlushbar.showError(context, 'File is too large (maximum 12MB)');
        return null;
      }

      final apiKeys = [
        RemoteConfigService.removeBgKey1,
        RemoteConfigService.removeBgKey2,
      ];

      for (final key in apiKeys) {
        try {
          var request = http.MultipartRequest(
            'POST',
            Uri.parse(ApiConstants.removeBgBaseUrl),
          );

          request.headers['X-Api-Key'] = key;
          request.files.add(
            await http.MultipartFile.fromPath('image_file', imageFile.path),
          );
          request.fields['size'] = 'auto';

          var response = await request.send();

          if (response.statusCode == 200) {
            Uint8List imageBytes = await response.stream.toBytes();
            final Directory tempDir = await getTemporaryDirectory();
            final String tempPath =
                '${tempDir.path}/no_bg_${DateTime.now().millisecondsSinceEpoch}.png';
            final File processedFile = File(tempPath);
            await processedFile.writeAsBytes(imageBytes);
            return processedFile;
          } else if (response.statusCode == 402 ||
              response.statusCode == 403 ||
              response.statusCode == 429) {
            continue;
          } else {
            throw Exception(
              'Background removal error (${response.statusCode})',
            );
          }
        } catch (_) {
          continue;
        }
      }
      AppFlushbar.showError(
        context,
        "Oops! Background removal service limit has been reached. Try again later.",
      );
      return null;
    } catch (e) {
      AppFlushbar.showError(context, "Remove.bg error: ${e.toString()}");
      return null;
    }
  }
}
