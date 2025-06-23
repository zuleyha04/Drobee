import 'dart:io';
import 'package:drobee/data/services/drive/drive_auth.dart';
import 'package:googleapis/drive/v3.dart' as drive;

class GoogleDriveService {
  static final GoogleDriveService _instance = GoogleDriveService._internal();
  factory GoogleDriveService() => _instance;
  GoogleDriveService._internal();

  final GoogleDriveAuth _auth = GoogleDriveAuth();

  // Fotoğrafı Drive'a yükleme
  Future<bool> uploadImageToDrive(
    File imageFile,
    String fileName, {
    Function(String)? onSuccess,
    Function(String)? onError,
  }) async {
    if (!_auth.hasPermission) {
      print('Drive izni yok');
      onError?.call('Drive izni yok. Lütfen önce Drive iznini verin.');
      return false;
    }

    if (_auth.driveApi == null) {
      print('Drive API hazır değil, yeniden başlatılıyor...');
      final hasPermission = await _auth.checkDrivePermission();
      if (!hasPermission) {
        print('Drive API yeniden başlatılamadı');
        onError?.call('Drive API yeniden başlatılamadı.');
        return false;
      }
    }

    try {
      print('Dosya yükleniyor: $fileName (${imageFile.lengthSync()} bytes)');

      final driveFile = drive.File();
      driveFile.name = fileName;
      driveFile.parents = ['appDataFolder']; // Uygulamaya özel klasör kullan

      final media = drive.Media(imageFile.openRead(), imageFile.lengthSync());

      final result = await _auth.driveApi!.files.create(
        driveFile,
        uploadMedia: media,
      );

      print(
        'Dosya başarıyla yüklendi - ID: ${result.id}, Name: ${result.name}',
      );
      onSuccess?.call('Fotoğraf başarıyla Drive\'a yüklendi!');
      return true;
    } catch (e) {
      print('Drive yükleme hatası: $e');

      // Token süresi dolmuşsa yenile
      if (e.toString().contains('401') ||
          e.toString().contains('Invalid Credentials')) {
        print('Token yenilenmeye çalışılıyor...');
        final renewed = await _auth.renewToken();
        if (renewed) {
          // Tekrar dene
          return uploadImageToDrive(
            imageFile,
            fileName,
            onSuccess: onSuccess,
            onError: onError,
          );
        }
      }

      onError?.call('Drive yükleme hatası: $e');
      return false;
    }
  }

  // Auth sınıfındaki metodlara proxy metodlar
  Future<bool> checkDrivePermission() => _auth.checkDrivePermission();
  Future<bool> requestDrivePermission() => _auth.requestDrivePermission();
  Future<void> revokeDrivePermission() => _auth.revokeDrivePermission();

  // Getter'lar
  bool get hasPermission => _auth.hasPermission;
  Future<bool> get isSignedIn => _auth.isSignedIn;
  Future<String?> get currentUserEmail => _auth.currentUserEmail;
}
