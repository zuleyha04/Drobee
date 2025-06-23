import 'dart:io';
import 'package:drobee/common/widget/button/custom_button.dart';
import 'package:drobee/core/configs/theme/app_colors.dart';
import 'package:drobee/core/utils/app_flushbar.dart';
import 'package:drobee/data/services/firebase_save_items.dart';
import 'package:drobee/data/services/google_drive_service.dart';
import 'package:drobee/data/services/photo_picker_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class PhotoPickerBottomSheet extends StatefulWidget {
  const PhotoPickerBottomSheet({super.key});

  @override
  State<PhotoPickerBottomSheet> createState() => _PhotoPickerBottomSheetState();
}

class _PhotoPickerBottomSheetState extends State<PhotoPickerBottomSheet> {
  File? _selectedImage;
  bool _isLoading = false;
  bool _isUploading = false;
  final List<String> _selectedWeathers = [];

  final GoogleDriveService _driveService = GoogleDriveService();

  static const List<String> _weatherOptions = [
    "Sunny",
    "Cloudy",
    "Rainy",
    "Snowy",
  ];

  Future<void> _pickImage(ImageSource source) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    setState(() {
      _selectedImage = null;
      _selectedWeathers.clear();
    });

    try {
      final image = await PhotoPickerService.pickImageWithBackgroundRemoval(
        source,
      );

      if (image != null && mounted) {
        setState(() => _selectedImage = image);
        AppFlushbar.showSuccess(
          context,
          'Photo processed and background removed!',
        );
      }
    } catch (e) {
      if (mounted) {
        AppFlushbar.showError(context, 'Hata: $e');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _removeImage() => setState(() => _selectedImage = null);

  void _toggleWeather(String weather) {
    setState(() {
      _selectedWeathers.contains(weather)
          ? _selectedWeathers.remove(weather)
          : _selectedWeathers.add(weather);
    });
  }

  Future<String?> _uploadToDrive() async {
    if (_selectedImage == null) {
      AppFlushbar.showError(context, 'Lütfen önce bir fotoğraf seçin.');
      return null;
    }

    if (_isUploading) return null;

    setState(() => _isUploading = true);

    try {
      final hasPermission = await _driveService.checkDrivePermission();
      if (!hasPermission) {
        final granted = await _driveService.requestDrivePermission();
        if (!granted) {
          AppFlushbar.showError(context, 'Google Drive izni verilmedi.');
          return null;
        }
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = path.extension(_selectedImage!.path);
      final fileName = 'background_removed_$timestamp$extension';

      final String? uploadedFileId =
          (await _driveService.uploadImageToDrive(
                _selectedImage!,
                fileName,
                onSuccess: (msg) => debugPrint('Upload success: $msg'),
                onError: (err) => debugPrint('Upload error: $err'),
              ))
              as String?;

      if (uploadedFileId != null) {
        debugPrint("Dosya ID: $uploadedFileId");
        AppFlushbar.showSuccess(
          context,
          'Fotoğraf başarıyla Drive\'a yüklendi!',
        );
        debugPrint("Fotoğraf yüklendi: $fileName");
        debugPrint("Etiketler: $_selectedWeathers");
        return uploadedFileId;
      } else {
        AppFlushbar.showError(context, 'Yükleme başarısız oldu.');
        return null;
      }
    } catch (e) {
      AppFlushbar.showError(context, 'Yükleme hatası: $e');
      return null;
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  void _handleSave() async {
    if (_selectedImage == null) {
      AppFlushbar.showError(context, 'Lütfen bir fotoğraf seçin.');
      return;
    }

    // Kullanıcı oturumunu kontrol et
    if (!FirebasePhotoService.isUserLoggedIn()) {
      AppFlushbar.showError(context, 'Lütfen önce giriş yapın.');
      return;
    }

    final fileId = await _uploadToDrive();

    if (mounted && !_isUploading && fileId != null) {
      debugPrint("Yüklenen dosyanın ID'si: $fileId");

      // Seçili olan chip'lerin listesi
      final selectedChips = List<String>.from(_selectedWeathers);
      debugPrint('Seçilen hava durumları: $selectedChips');

      // Firebase'e kaydet
      final saveSuccess = await FirebasePhotoService.savePhotoToFirebase(
        imageId: fileId,
        weatherTags: selectedChips,
      );

      if (saveSuccess) {
        AppFlushbar.showSuccess(
          context,
          'Fotoğraf ve etiketler başarıyla kaydedildi!',
        );

        // İşlem bitince image ve chips'leri sıfırla
        setState(() {
          _selectedImage = null;
          _selectedWeathers.clear();
        });

        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      } else {
        AppFlushbar.showError(
          context,
          'Fotoğraf kaydedilirken bir hata oluştu.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildPhotoArea(),
                  const SizedBox(height: 16),
                  _buildActionButtons(),
                  const SizedBox(height: 16),
                  _buildWeatherChips(),
                  const SizedBox(height: 20),
                  _buildSaveButton(),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Add Your Items",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () {
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoArea() {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(child: _buildPhotoContent()),
      ),
    );
  }

  Widget _buildPhotoContent() {
    if (_isLoading) {
      return const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading...'),
        ],
      );
    }

    if (_selectedImage != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              _selectedImage!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: _removeImage,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.image_outlined, size: 48, color: Colors.grey.shade500),
        const SizedBox(height: 10),
        Text(
          "Add Photo",
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed:
                _isLoading ? null : () => _pickImage(ImageSource.gallery),
            icon: const Icon(Icons.photo),
            label: const Text("Gallery"),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              side: const BorderSide(color: AppColors.primary),
              foregroundColor: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _isLoading ? null : () => _pickImage(ImageSource.camera),
            icon: const Icon(Icons.camera_alt),
            label: const Text("Camera"),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              side: const BorderSide(color: AppColors.primary),
              foregroundColor: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherChips() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children:
          _weatherOptions.map((weather) {
            final isSelected = _selectedWeathers.contains(weather);
            return ChoiceChip(
              label: Text(weather),
              selected: isSelected,
              onSelected: (_) => _toggleWeather(weather),
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : Colors.grey,
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildSaveButton() {
    return CustomButton(
      onTap: _isUploading ? () {} : _handleSave,
      text: 'Save',
    );
  }
}
