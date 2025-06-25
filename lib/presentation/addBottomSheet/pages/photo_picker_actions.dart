import 'package:drobee/presentation/addBottomSheet/cubit/phote_picker_cubit.dart';
import 'package:drobee/presentation/addBottomSheet/cubit/photo_picker_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:drobee/core/configs/theme/app_colors.dart';

class PhotoPickerActions extends StatelessWidget {
  const PhotoPickerActions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoPickerCubit, PhotoPickerState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed:
                    state.hasAnyLoading
                        ? null
                        : () => context.read<PhotoPickerCubit>().pickImage(
                          ImageSource.gallery,
                        ),
                icon: const Icon(Icons.photo),
                label: const Text("Gallery"),
                style: _buttonStyle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed:
                    state.hasAnyLoading
                        ? null
                        : () => context.read<PhotoPickerCubit>().pickImage(
                          ImageSource.camera,
                        ),
                icon: const Icon(Icons.camera_alt),
                label: const Text("Camera"),
                style: _buttonStyle,
              ),
            ),
          ],
        );
      },
    );
  }

  ButtonStyle get _buttonStyle => OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    side: const BorderSide(color: AppColors.primary),
    foregroundColor: AppColors.primary,
  );
}
