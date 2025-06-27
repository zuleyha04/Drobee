import 'package:cloud_firestore/cloud_firestore.dart';

class UserImageModel {
  final String id;
  final String userId;
  final String imageUrl;
  final List<String> weatherTags;
  final Timestamp? createdAt;

  UserImageModel({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.weatherTags,
    this.createdAt,
  });
}
