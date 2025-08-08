import 'package:drobee/presentation/home/models/user_image_model.dart';

class HomeState {
  final String? email;
  final bool isLoading;
  final String? error;
  final List<UserImageModel> userImages;
  final int todayUploadCount;

  const HomeState({
    this.email,
    this.isLoading = false,
    this.error,
    this.userImages = const [],
    this.todayUploadCount = 0,
  });

  HomeState copyWith({
    String? email,
    bool? isLoading,
    String? error,
    List<UserImageModel>? userImages,
  }) {
    return HomeState(
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      userImages: userImages ?? this.userImages,
    );
  }

  List<UserImageModel> get todayImages {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    return userImages.where((img) {
      if (img.createdAt != null) {
        return img.createdAt!.toDate().isAfter(startOfDay);
      }
      return false;
    }).toList();
  }
}
