import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebasePhotoService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Kullanıcının fotoğrafını ve hava durumu etiketlerini Firebase'e kaydeder
  static Future<bool> savePhotoToFirebase({
    required String imageId,
    required List<String> weatherTags,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        debugPrint('Kullanıcı oturumu bulunamadı');
        return false;
      }

      await _firestore.collection('user_photos').add({
        'userId': user.uid,
        'imageId': imageId,
        'weathers': weatherTags,
        'createdAt': FieldValue.serverTimestamp(),
        'userEmail': user.email,
      });

      debugPrint('Firestore\'a başarıyla kaydedildi');
      debugPrint('User ID: ${user.uid}');
      debugPrint('Image ID: $imageId');
      debugPrint('Weather Tags: $weatherTags');

      return true;
    } catch (e) {
      debugPrint('Firestore kaydetme hatası: $e');
      return false;
    }
  }

  /// Kullanıcının tüm fotoğraflarını getirir
  static Future<List<Map<String, dynamic>>> getUserPhotos() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        debugPrint('Kullanıcı oturumu bulunamadı');
        return [];
      }

      final querySnapshot =
          await _firestore
              .collection('user_photos')
              .where('userId', isEqualTo: user.uid)
              .orderBy('createdAt', descending: true)
              .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['docId'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      debugPrint('Fotoğrafları getirme hatası: $e');
      return [];
    }
  }

  /// Belirli bir fotoğrafı siler
  static Future<bool> deletePhoto(String docId) async {
    try {
      await _firestore.collection('user_photos').doc(docId).delete();
      debugPrint('Fotoğraf silindi: $docId');
      return true;
    } catch (e) {
      debugPrint('Fotoğraf silme hatası: $e');
      return false;
    }
  }

  /// Kullanıcının oturum açıp açmadığını kontrol eder
  static bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }

  /// Mevcut kullanıcının bilgilerini getirir
  static User? getCurrentUser() {
    return _auth.currentUser;
  }
}
