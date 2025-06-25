import 'package:cloud_firestore/cloud_firestore.dart';

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
        .orderBy('created_at', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList(),
        );
  }
}
