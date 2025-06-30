import 'dart:convert';
import 'package:drobee/common/constants/api_constants.dart';
import 'package:drobee/presentation/weather/model/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<WeatherModel> getCurrentWeather(String cityName) async {
    final url =
        '${ApiConstants.weatherBaseUrl}/weather?q=$cityName&appid=${ApiConstants.weatherApiKey}&units=metric&lang=tr';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception(
          'Şehir bulunamadı. Lütfen geçerli bir şehir adı girin.',
        );
      } else {
        throw Exception('Hava durumu bilgisi alınamadı');
      }
    } catch (e) {
      if (e.toString().contains('Şehir bulunamadı')) {
        rethrow;
      }
      throw Exception('Bağlantı hatası. İnternet bağlantınızı kontrol edin.');
    }
  }
}
