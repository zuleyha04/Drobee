import 'dart:convert';
import 'package:drobee/common/constants/api_constants.dart';
import 'package:drobee/presentation/weather/model/weather_model.dart';
import 'package:drobee/data/services/remote_config_service.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<WeatherModel> getCurrentWeather(String cityName) async {
    final apiKey = RemoteConfigService.weatherApiKey;

    final url =
        '${ApiConstants.weatherBaseUrl}/weather?q=$cityName&appid=$apiKey&units=metric&lang=en';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('City not found. Please enter a valid city name.');
      } else {
        throw Exception('Failed to retrieve weather information.');
      }
    } catch (e) {
      if (e.toString().contains('City not found')) {
        rethrow;
      }
      throw Exception(
        'Connection error. Please check your internet connection.',
      );
    }
  }
}
