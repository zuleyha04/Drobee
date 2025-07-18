import 'package:drobee/presentation/home/widgets/image_card.dart';
import 'package:drobee/presentation/home/cubit/home_cubit.dart';
import 'package:drobee/presentation/home/cubit/home_state.dart';
import 'package:drobee/presentation/weather/cubit/weather_cubit.dart';
import 'package:drobee/presentation/weather/cubit/weather_state.dart';
import 'package:drobee/presentation/weather/utils/weather_utils.dart';
import 'package:drobee/presentation/weather/widgets/weather_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeatherInfoArea extends StatelessWidget {
  final TextEditingController cityController;

  const WeatherInfoArea({super.key, required this.cityController});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return BlocBuilder<WeatherCubit, WeatherState>(
          builder: (context, weatherState) {
            if (weatherState is WeatherInitial) {
              return Center(
                child: Text(
                  'Enter a city name to get the weather',
                  style: TextStyle(fontSize: 18.sp),
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
                    Icon(Icons.error, size: 48.sp, color: Colors.red),
                    SizedBox(height: 16.h),
                    Text(
                      weatherState.message,
                      style: TextStyle(fontSize: 16.sp),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        final city = cityController.text.trim();
                        context.read<WeatherCubit>().getWeatherByCity(
                          city.isNotEmpty ? city : 'Ankara',
                        );
                      },
                      child: Text(
                        'Try Again',
                        style: TextStyle(fontSize: 14.sp),
                      ),
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

                  final keyboardHeight =
                      MediaQuery.of(context).viewInsets.bottom;
                  final availableHeight =
                      constraints.maxHeight - keyboardHeight;

                  return SizedBox(
                    height:
                        availableHeight > 0
                            ? availableHeight
                            : constraints.maxHeight,
                    child: SingleChildScrollView(
                      physics:
                          keyboardHeight > 0
                              ? const AlwaysScrollableScrollPhysics()
                              : const NeverScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight:
                              availableHeight > 0
                                  ? availableHeight
                                  : constraints.maxHeight,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: WeatherInfoCard(
                                weather: weatherState.weather,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Text(
                                "Items suitable for this weather:",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            SizedBox(
                              height:
                                  (availableHeight > 0
                                      ? availableHeight
                                      : constraints.maxHeight) -
                                  200.h,
                              child:
                                  filteredImages.isEmpty
                                      ? Center(
                                        child: Text(
                                          "No items found for this weather.",
                                          style: TextStyle(fontSize: 14.sp),
                                        ),
                                      )
                                      : GridView.builder(
                                        padding: EdgeInsets.all(8.w),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              mainAxisSpacing: 8.h,
                                              crossAxisSpacing: 8.w,
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
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}
