import 'package:drobee/presentation/weather/cubit/weather_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CitySearchCard extends StatelessWidget {
  final TextEditingController cityController;

  const CitySearchCard({super.key, required this.cityController});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: cityController,
              decoration: const InputDecoration(
                hintText: 'Enter a city name',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.location_city),
              ),
              onSubmitted: (value) {
                if (context.mounted && value.trim().isNotEmpty) {
                  context.read<WeatherCubit>().getWeatherByCity(value);
                }
              },
            ),
          ),
          IconButton(
            onPressed: () {
              if (context.mounted && cityController.text.trim().isNotEmpty) {
                context.read<WeatherCubit>().getWeatherByCity(
                  cityController.text,
                );
              }
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}
