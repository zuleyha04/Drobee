import 'dart:io';
import 'package:drobee/common/widget/button/custom_button.dart';
import 'package:drobee/core/configs/theme/app_colors.dart';
import 'package:drobee/core/utils/app_flushbar.dart';
import 'package:drobee/data/photo_picker_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoPickerBottomSheet extends StatefulWidget {
  const PhotoPickerBottomSheet({super.key});

  @override
  State<PhotoPickerBottomSheet> createState() => _PhotoPickerBottomSheetState();
}

class _PhotoPickerBottomSheetState extends State<PhotoPickerBottomSheet> {
  File? _selectedImage;
  bool _isLoading = false;
  final List<String> _selectedWeathers = [];

  static const List<String> _weatherOptions = [
    "Sunny",
    "Cloudy",
    "Rainy",
    "Snowy",
  ];

  Future<void> _pickImage(ImageSource source) async {
    setState(() => _isLoading = true);

    try {
      final image = await PhotoPickerService.pickImage(source);
      if (image != null && mounted) {
        setState(() => _selectedImage = image);
        AppFlushbar.showSuccess(context, '✅ Fotoğraf başarıyla seçildi!');
      }
    } catch (e) {
      if (mounted) {
        AppFlushbar.showError(context, '❌ Hata: $e');
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

  void _handleSave() {
    print("Seçilen hava etiketleri: $_selectedWeathers");
    AppFlushbar.showSuccess(context, 'Kaydedildi.');
    Navigator.pop(context);
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
          // Header
          _buildHeader(),

          // Content
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
            onPressed: () => Navigator.pop(context),
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
    return CustomButton(onTap: _handleSave, text: 'Save');
  }
}
