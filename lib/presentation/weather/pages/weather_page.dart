import 'package:drobee/data/services/weather_service.dart';
import 'package:drobee/presentation/weather/cubit/weather_cubit.dart';
import 'package:drobee/presentation/weather/pages/weather_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherCubit(WeatherService()),
      child: const WeatherView(),
    );
  }
}
