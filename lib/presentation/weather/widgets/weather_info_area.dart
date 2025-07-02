import 'package:drobee/presentation/home/widgets/image_card.dart';
import 'package:drobee/presentation/home/cubit/home_cubit.dart';
import 'package:drobee/presentation/home/cubit/home_state.dart';
import 'package:drobee/presentation/weather/cubit/weather_cubit.dart';
import 'package:drobee/presentation/weather/cubit/weather_state.dart';
import 'package:drobee/presentation/weather/utils/weather_utils.dart';
import 'package:drobee/presentation/weather/widgets/weather_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherInfoArea extends StatelessWidget {
  final TextEditingController cityController;

  const WeatherInfoArea({super.key, required this.cityController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, weatherState) {
        if (weatherState is WeatherInitial) {
          return const Center(
            child: Text(
              'Şehir adını girin ve hava durumunu öğrenin',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          );
        } else if (weatherState is WeatherLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (weatherState is WeatherError) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  weatherState.message,
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
        } else if (weatherState is WeatherLoaded) {
          final rawDescription = weatherState.weather.description;
          final weatherTag = mapDescriptionToTag(rawDescription);

          return BlocBuilder<HomeCubit, HomeState>(
            builder: (context, homeState) {
              final allImages = homeState.userImages;

              final filteredImages =
                  allImages.where((img) {
                    return img.weatherTags.contains(weatherTag);
                  }).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: WeatherInfoCard(weather: weatherState.weather),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "Bu hava durumuna uygun parçalar: ($weatherTag)",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child:
                        filteredImages.isEmpty
                            ? const Center(
                              child: Text(
                                "Bu hava durumuna uygun parça bulunamadı.",
                              ),
                            )
                            : GridView.builder(
                              padding: const EdgeInsets.all(8),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                  ),
                              itemCount: filteredImages.length,
                              itemBuilder: (context, index) {
                                return ImageCard(
                                  image: filteredImages[index],
                                  showDeleteButton: false,
                                );
                              },
                            ),
                  ),
                ],
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
