import 'dart:io';
import 'dart:convert';
import 'package:drobee/common/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class FreeImageHostService {
  static Future<String?> uploadImage(File imageFile) async {
    try {
      // Dosyayı base64'e çevir
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // API isteği hazırla
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.imageHostBaseUrl),
      );
      request.fields['key'] = ApiConstants.imageHostApiKey;

      request.fields['source'] = base64Image;
      request.fields['format'] = 'json';

      // İsteği gönder
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        if (jsonResponse['status_code'] == 200) {
          return jsonResponse['image']['url'];
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
