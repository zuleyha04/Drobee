import 'package:drobee/presentation/addBottomSheet/cubit/phote_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drobee/core/configs/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeatherChips extends StatelessWidget {
  final List<String> options;
  const WeatherChips({super.key, required this.options});

  @override
  Widget build(BuildContext context) {
    final selected = context.select(
      (PhotoPickerCubit cubit) => cubit.state.selectedWeathers,
    );

    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children:
          options.map((weather) {
            final isSelected = selected.contains(weather);
            return ChoiceChip(
              label: Text(weather),
              selected: isSelected,
              onSelected:
                  (_) =>
                      context.read<PhotoPickerCubit>().toggleWeather(weather),
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : Colors.grey,
                ),
              ),
            );
          }).toList(),
    );
  }
}
