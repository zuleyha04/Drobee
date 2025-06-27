import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drobee/presentation/home/models/user_image_model.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> saveUserPhoto({
    required String userId,
    required String imageUrl,
    required List<String> weatherTags,
  }) async {
    final docRef = _firestore.collection('user_photos').doc();

    await docRef.set({
      'user_id': userId,
      'image_url': imageUrl,
      'weather_tags': weatherTags,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  static Stream<List<Map<String, dynamic>>> getUserPhotosStream(String userId) {
    return _firestore
        .collection('user_photos')
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList(),
        );
  }

  Stream<List<UserImageModel>> getUserImages(String userId) {
    return _firestore
        .collection('user_images')
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();

            return UserImageModel(
              id: doc.id,
              userId: data['user_id'] ?? '',
              imageUrl: data['image_url'] ?? '',
              weatherTags: List<String>.from(data['weather_tags'] ?? []),
              createdAt: data['created_at'] as Timestamp?,
            );
          }).toList();
        });
  }

  Future<void> deleteUserImage(String imageId) async {
    await _firestore.collection('user_images').doc(imageId).delete();
  }
}
