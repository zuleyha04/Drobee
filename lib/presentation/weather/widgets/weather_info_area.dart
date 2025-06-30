import 'package:drobee/presentation/weather/cubit/weather_cubit.dart';
import 'package:drobee/presentation/weather/cubit/weather_state.dart';
import 'package:drobee/presentation/weather/widgets/weather_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherInfoArea extends StatelessWidget {
  final TextEditingController cityController;

  const WeatherInfoArea({super.key, required this.cityController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        if (state is WeatherInitial) {
          return const Center(
            child: Text(
              'Şehir adını girin ve hava durumunu öğrenin',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          );
        } else if (state is WeatherLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is WeatherLoaded) {
          return Align(
            alignment: Alignment.topCenter,
            child: WeatherInfoCard(weather: state.weather),
          );
        } else if (state is WeatherError) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final city = cityController.text.trim();
                    context.read<WeatherCubit>().getWeatherByCity(
                      city.isNotEmpty ? city : 'Ankara',
                    );
                  },
                  child: const Text('Tekrar Dene'),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
