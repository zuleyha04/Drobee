import 'package:drobee/common/widget/pageTitle/page_title.dart';
import 'package:drobee/presentation/weather/cubit/weather_cubit.dart';
import 'package:drobee/presentation/weather/widgets/city_search_card.dart';
import 'package:drobee/presentation/weather/widgets/weather_info_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<WeatherCubit>().getWeatherByCity('Ankara');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const PageTitle('Weather'),
              CitySearchCard(cityController: _cityController),
              const SizedBox(height: 10),
              Expanded(child: WeatherInfoArea(cityController: _cityController)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}
