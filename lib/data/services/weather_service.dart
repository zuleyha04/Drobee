import 'dart:convert';
import 'package:drobee/common/constants/api_constants.dart';
import 'package:drobee/presentation/weather/model/weather_model.dart';
import 'package:drobee/data/services/remote_config_service.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<WeatherModel> getCurrentWeather(String cityName) async {
    String apiKey = RemoteConfigService.weatherApiKey;

    Future<WeatherModel> fetchWeather(String key) async {
      final url =
          '${ApiConstants.weatherBaseUrl}/weather?q=$cityName&appid=$key&units=metric&lang=en';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else if (response.statusCode == 401 || response.statusCode == 429) {
        throw Exception('Quota or auth error');
      } else if (response.statusCode == 404) {
        throw Exception('City not found. Please enter a valid city name.');
      } else {
        throw Exception('Failed to retrieve weather information.');
      }
    }

    try {
      return await fetchWeather(apiKey);
    } catch (e) {
      if (e.toString().contains('Quota') || e.toString().contains('auth')) {
        // Kota dolduysa veya key geçersizse yeni key fetch et
        await RemoteConfigService.forceFetch();
        final newKey = RemoteConfigService.weatherApiKey;
        return await fetchWeather(newKey);
      }
      rethrow;
    }
  }
}
