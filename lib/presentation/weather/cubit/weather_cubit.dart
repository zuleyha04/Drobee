import 'package:drobee/data/services/weather_service.dart';
import 'package:drobee/presentation/weather/cubit/weather_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherService _weatherService;

  WeatherCubit(this._weatherService) : super(WeatherInitial());

  Future<void> getWeatherByCity(String cityName) async {
    if (isClosed) return;

    if (cityName.trim().isEmpty) {
      if (!isClosed) emit(const WeatherError('Please enter a city name'));
      return;
    }

    try {
      if (!isClosed) emit(WeatherLoading());
      final weather = await _weatherService.getCurrentWeather(cityName.trim());
      if (!isClosed) emit(WeatherLoaded(weather));
    } catch (e) {
      if (!isClosed) {
        emit(WeatherError(e.toString().replaceAll('Exception: ', '')));
      }
    }
  }
}
