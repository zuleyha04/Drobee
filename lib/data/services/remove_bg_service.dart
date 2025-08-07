import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:drobee/common/constants/api_constants.dart';
import 'package:drobee/data/services/remote_config_service.dart';
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

      // 5 API KEY kullanımı
      List<String> apiKeys = [
        RemoteConfigService.removeBgKey1,
        RemoteConfigService.removeBgKey2,
        RemoteConfigService.removeBgKey3,
        RemoteConfigService.removeBgKey4,
        RemoteConfigService.removeBgKey5,
      ];

      for (int i = 0; i < apiKeys.length; i++) {
        final key = apiKeys[i];

        // Kalan hak bilgisini yazdır
        await _printRemainingCredits(key, i + 1);

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
            if (i == 0 || i == 2) {
              await RemoteConfigService.forceFetch();
              apiKeys = [
                RemoteConfigService.removeBgKey1,
                RemoteConfigService.removeBgKey2,
                RemoteConfigService.removeBgKey3,
                RemoteConfigService.removeBgKey4,
                RemoteConfigService.removeBgKey5,
              ];
            }
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

      throw Exception('All API keys failed or quota exceeded');
    } catch (e) {
      throw Exception('Remove.bg error: $e');
    }
  }

  static Future<void> _printRemainingCredits(
    String apiKey,
    int keyIndex,
  ) async {
    try {
      if (apiKey.trim().isEmpty) {
        print('[Key $keyIndex] API key is empty. Skipping.');
        return;
      }

      final uri = Uri.parse('https://api.remove.bg/v1.0/account');
      final response = await http.get(uri, headers: {'X-Api-Key': apiKey});

      print('[Key $keyIndex] Status Code: ${response.statusCode}');
      print('[Key $keyIndex] Body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        final attributes = json['data']?['attributes'];
        final credits = attributes?['credits'];

        if (credits != null) {
          final total = credits['total'];
          final subscription = credits['subscription'];
          final payg = credits['payg'];
          final enterprise = credits['enterprise'];

          print(
            '[Key $keyIndex] Remaining credits → total: $total, subscription: $subscription, pay-as-you-go: $payg, enterprise: $enterprise',
          );
        } else {
          print('[Key $keyIndex] Credit info not found in response.');
        }
      } else {
        print(
          '[Key $keyIndex] Failed to fetch credit info: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('[Key $keyIndex] Error while checking credit info: $e');
    }
  }
}
