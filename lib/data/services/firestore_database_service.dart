import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drobee/presentation/home/models/user_image_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  static Future<void> deleteCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.delete();
    }
  }

  /// Kullanıcının tüm outfit kombinlerini getir
  static Stream<List<Map<String, dynamic>>> getUserOutfitsStream() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return const Stream.empty();

    return _firestore
        .collection('user_outfits')
        .where('user_id', isEqualTo: currentUser.uid)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) {
                final data = doc.data();
                data['id'] = doc.id;
                return data;
              }).toList(),
        );
  }

  /// Outfit'i sil
  static Future<void> deleteOutfit(String outfitId) async {
    await _firestore.collection('user_outfits').doc(outfitId).delete();
  }
}
