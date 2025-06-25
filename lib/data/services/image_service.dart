import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FreeImageHostService {
  static const String _apiKey = '6d207e02198a847aa98d0a2a901485a5';
  static const String _baseUrl = 'https://freeimage.host/api/1/upload';

  static Future<String?> uploadImage(File imageFile) async {
    try {
      // Dosyayı base64'e çevir
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // API isteği hazırla
      var request = http.MultipartRequest('POST', Uri.parse(_baseUrl));

      // API key ekle
      request.fields['key'] = _apiKey;

      // Resmi ekle
      request.fields['source'] = base64Image;
      request.fields['format'] = 'json';

      // İsteği gönder
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        // Başarılı yanıt kontrolü
        if (jsonResponse['status_code'] == 200) {
          return jsonResponse['image']['url'];
        } else {
          print('FreeImage.host error: ${jsonResponse['error']['message']}');
          return null;
        }
      } else {
        print('HTTP error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }
}
