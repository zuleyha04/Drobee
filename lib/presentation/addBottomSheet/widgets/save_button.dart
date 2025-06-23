import 'package:drobee/common/widget/button/custom_button.dart';
import 'package:drobee/core/utils/app_flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drobee/presentation/addBottomSheet/cubit/phote_picker_cubit.dart';
import 'package:drobee/presentation/addBottomSheet/cubit/photo_picker_state.dart';
import 'package:drobee/core/configs/theme/app_colors.dart';
// AppFlushbar import'unu ekleyin
// import 'package:drobee/core/widgets/app_flushbar.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoPickerCubit, PhotoPickerState>(
      builder: (context, state) {
        return Column(
          children: [
            // Seçilen hava durumları göster
            if (state.selectedWeathers.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
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

            // Mevcut CustomButton yapınızla uyumlu save butonu
            CustomButton(
              onTap:
                  state.isUploading
                      ? () {}
                      : () {
                        // Önce validasyon kontrolleri
                        if (state.selectedImage == null) {
                          AppFlushbar.showError(
                            context,
                            'Lütfen bir fotoğraf seçin',
                          );
                          return;
                        }

                        if (state.selectedWeathers.isEmpty) {
                          AppFlushbar.showError(
                            context,
                            'Lütfen en az bir hava durumu seçin',
                          );
                          return;
                        }

                        // Mevcut handleSave fonksiyonunuzu çağır
                        context.read<PhotoPickerCubit>().handleSave((fileId) {
                          AppFlushbar.showSuccess(
                            context,
                            'Fotoğraf ve etiketler başarıyla kaydedildi!',
                          );
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        }, (error) => AppFlushbar.showError(context, error));
                      },
              text: 'Save',
            ),
          ],
        );
      },
    );
  }
}
