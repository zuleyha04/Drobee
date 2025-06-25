import 'package:drobee/common/widget/button/custom_button.dart';
import 'package:drobee/core/utils/app_flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drobee/presentation/addBottomSheet/cubit/phote_picker_cubit.dart';
import 'package:drobee/presentation/addBottomSheet/cubit/photo_picker_state.dart';
import 'package:drobee/core/configs/theme/app_colors.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PhotoPickerCubit, PhotoPickerState>(
      listener: (context, state) {
        // Başarı mesajını dinle
        if (state.successMessage != null) {
          Future.delayed(const Duration(milliseconds: 100), () {
            AppFlushbar.showSuccess(context, state.successMessage!);
            // Mesajı temizle
            context.read<PhotoPickerCubit>().clearMessages();
            // Bottom sheet'i kapat
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          });
        }

        // Hata mesajını dinle
        if (state.error != null) {
          Future.delayed(Duration.zero, () {
            AppFlushbar.showError(context, state.error!);
            // Mesajı temizle
            context.read<PhotoPickerCubit>().clearMessages();
          });
        }
      },
      child: BlocBuilder<PhotoPickerCubit, PhotoPickerState>(
        builder: (context, state) {
          return Column(
            children: [
              // İşleniyor durumu (metinle)
              if (state.isProcessing)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: const Text(
                    'Arka plan siliniyor...',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.orange,
                    ),
                  ),
                ),

              // Seçilen hava durumları
              if (state.selectedWeathers.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seçilen Hava Durumları:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children:
                            state.selectedWeathers.map((weather) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  weather,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                ),

              // Yükleniyor durumu (metinle)
              if (state.isUploading)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: const Text(
                    'Resim yükleniyor ve veritabanına kaydediliyor...',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                    ),
                  ),
                ),

              // Save Butonu
              CustomButton(
                onTap:
                    state.hasAnyLoading
                        ? () {}
                        : () {
                          // savePhotoWithWeathers fonksiyonunu çağır
                          context
                              .read<PhotoPickerCubit>()
                              .savePhotoWithWeathers();
                        },
                text:
                    state.isUploading
                        ? 'Kaydediliyor...'
                        : state.isProcessing
                        ? 'İşleniyor...'
                        : 'Save',
              ),
            ],
          );
        },
      ),
    );
  }
}
