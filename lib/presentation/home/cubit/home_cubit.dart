import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drobee/presentation/home/models/user_image_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:drobee/presentation/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final FirebaseAuth _firebaseAuth;
  StreamSubscription<List<UserImageModel>>? _imagesSubscription;

  HomeCubit(this._firebaseAuth) : super(const HomeState()) {
    _initializeUser();
  }

  void _initializeUser() {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      emit(state.copyWith(email: user.email));
      _loadUserImages(user.uid);
    }
  }

  void _loadUserImages(String userId) {
    _imagesSubscription?.cancel();

    if (_firebaseAuth.currentUser == null) {
      emit(state.copyWith(error: 'Kullanıcı girişi gerekli'));
      return;
    }

    _imagesSubscription = _getUserImagesStream(userId).listen(
      (images) {
        emit(state.copyWith(userImages: images));
      },
      onError: (error) {
        print('Firestore Error: $error');
        emit(state.copyWith(error: 'Veri yükleme hatası: ${error.toString()}'));
      },
    );
  }

  Stream<List<UserImageModel>> _getUserImagesStream(String userId) {
    return FirebaseFirestore.instance
        .collection('user_photos')
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final docs =
              snapshot.docs.map((doc) {
                final data = doc.data();
                return UserImageModel(
                  id: doc.id,
                  userId: data['user_id'] ?? '',
                  imageUrl: data['image_url'] ?? '',
                  weatherTags: List<String>.from(data['weather_tags'] ?? []),
                  createdAt: data['created_at'] as Timestamp?,
                );
              }).toList();
          return docs;
        });
  }

  Future<void> logout() async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      await _firebaseAuth.signOut();
      emit(HomeState(email: null));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> deleteImage(String imageId) async {
    await FirebaseFirestore.instance
        .collection('user_photos')
        .doc(imageId)
        .delete();
  }

  @override
  Future<void> close() {
    _imagesSubscription?.cancel();
    return super.close();
  }
}
