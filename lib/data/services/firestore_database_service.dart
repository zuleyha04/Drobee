import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drobee/presentation/home/models/user_image_model.dart';
import 'package:drobee/presentation/stylePage/models/outfit_data_model.dart';
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

  static Future<void> deleteCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.delete();
    }
  }

  /// Outfit kombinini kaydet
  static Future<String> saveOutfitCombination({
    required List<DraggableImageItem> outfitItems,
    String? outfitName,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception('Kullanıcı oturumu açık değil');
    final userId = currentUser.uid;

    final docRef = _firestore.collection('user_outfits').doc();

    final outfitItemsData =
        outfitItems
            .map(
              (item) => {
                'id': item.id,
                'image_url': item.imageUrl,
                'position_x': item.position.dx,
                'position_y': item.position.dy,
                'rotation': item.rotation,
                'scale': item.scale,
              },
            )
            .toList();

    await docRef.set({
      'user_id': userId,
      'outfit_name':
          outfitName ?? 'Outfit ${DateTime.now().millisecondsSinceEpoch}',
      'outfit_items': outfitItemsData,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    });

    return docRef.id;
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
                final data = doc.data() as Map<String, dynamic>;
                data['id'] = doc.id;
                return data;
              }).toList(),
        );
  }

  /// Belirli bir outfit'i getir
  static Future<Map<String, dynamic>?> getOutfitById(String outfitId) async {
    final doc = await _firestore.collection('user_outfits').doc(outfitId).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }
    return null;
  }

  /// Outfit'i güncelle
  static Future<void> updateOutfit({
    required String outfitId,
    required List<DraggableImageItem> outfitItems,
    String? outfitName,
  }) async {
    final outfitItemsData =
        outfitItems
            .map(
              (item) => {
                'id': item.id,
                'image_url': item.imageUrl,
                'position_x': item.position.dx,
                'position_y': item.position.dy,
                'rotation': item.rotation,
                'scale': item.scale,
              },
            )
            .toList();

    final updateData = {
      'outfit_items': outfitItemsData,
      'updated_at': FieldValue.serverTimestamp(),
    };
    //TODO:buna gerek yok
    if (outfitName != null) {
      updateData['outfit_name'] = outfitName;
    }

    await _firestore
        .collection('user_outfits')
        .doc(outfitId)
        .update(updateData);
  }

  /// Outfit'i sil
  static Future<void> deleteOutfit(String outfitId) async {
    await _firestore.collection('user_outfits').doc(outfitId).delete();
  }

  /// Firestore verisini DraggableImageItem listesine dönüştür
  static List<DraggableImageItem> convertFirestoreToOutfitItems(
    List<dynamic> firestoreData,
  ) {
    return firestoreData.map((item) {
      final itemMap = item as Map<String, dynamic>;
      return DraggableImageItem(
        id: itemMap['id'] ?? '',
        imageUrl: itemMap['image_url'] ?? '',
        position: Offset(
          (itemMap['position_x'] ?? 0.0).toDouble(),
          (itemMap['position_y'] ?? 0.0).toDouble(),
        ),
        rotation: (itemMap['rotation'] ?? 0.0).toDouble(),
        scale: (itemMap['scale'] ?? 1.0).toDouble(),
      );
    }).toList();
  }
}
