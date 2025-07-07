import 'package:flutter/material.dart';

class SelectedImageData {
  final String id;
  final String imageUrl;

  SelectedImageData({required this.id, required this.imageUrl});
}

class ClothesSelectionResult {
  final List<SelectedImageData> selectedImages;

  ClothesSelectionResult({required this.selectedImages});
}

class DraggableImageItem {
  final String id;
  final String imageUrl;
  Offset position;
  double rotation;
  double scale; // Yeni eklenen scale özelliği

  DraggableImageItem({
    required this.id,
    required this.imageUrl,
    required this.position,
    required this.rotation,
    this.scale = 1.0, // Varsayılan değer
  });
}
