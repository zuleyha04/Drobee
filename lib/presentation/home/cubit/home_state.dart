import 'package:drobee/presentation/home/models/user_image_model.dart';

class HomeState {
  final String? email;
  final bool isLoading;
  final String? error;
  final List<UserImageModel> userImages;

  const HomeState({
    this.email,
    this.isLoading = false,
    this.error,
    this.userImages = const [],
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
}
