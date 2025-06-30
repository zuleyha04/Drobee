import 'package:drobee/presentation/weather/pages/weather_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drobee/presentation/home/cubit/home_cubit.dart';
import 'package:drobee/presentation/weather/cubit/weather_cubit.dart';
import 'package:drobee/data/services/weather_service.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WeatherCubit>(
          create: (context) => WeatherCubit(WeatherService()),
        ),
        BlocProvider<HomeCubit>.value(
          value: BlocProvider.of<HomeCubit>(context),
        ),
      ],
      child: const WeatherView(),
    );
  }
}
