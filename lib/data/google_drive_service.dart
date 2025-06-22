import 'dart:io';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GoogleDriveService {
  static final GoogleDriveService _instance = GoogleDriveService._internal();
  factory GoogleDriveService() => _instance;
  GoogleDriveService._internal();

  drive.DriveApi? _driveApi;
  GoogleSignIn? _googleSignIn;
  bool _isInitialized = false;
  bool _hasPermission = false;

  // Drive servisini başlat
  Future<void> _initializeService() async {
    if (_isInitialized) return;

    _googleSignIn = GoogleSignIn(
      scopes: [
        'https://www.googleapis.com/auth/drive.file',
        'https://www.googleapis.com/auth/drive.appdata',
      ],
    );
    _isInitialized = true;
  }

  // Drive izni kontrolü - Geliştirilmiş versiyon
  Future<bool> checkDrivePermission() async {
    await _initializeService();

    final prefs = await SharedPreferences.getInstance();
    final savedPermission = prefs.getBool('drive_permission') ?? false;

    print('Kayıtlı Drive izni: $savedPermission');

    if (savedPermission) {
      // Daha önce izin verilmişse, gerçekten geçerli mi kontrol et
      try {
        final isCurrentlySignedIn = await _googleSignIn!.isSignedIn();
        print('Şu anda giriş yapılmış mı: $isCurrentlySignedIn');

        if (isCurrentlySignedIn) {
          final account = _googleSignIn!.currentUser;
          if (account != null) {
            await _setupDriveApi(account);
            _hasPermission = true;
            print('Mevcut oturum ile Drive API hazırlandı');
            return true;
          }
        }

        // Sessiz giriş dene
        final account = await _googleSignIn!.signInSilently();
        if (account != null) {
          await _setupDriveApi(account);
          _hasPermission = true;
          print('Sessiz giriş başarılı');
          return true;
        } else {
          print('Sessiz giriş yapılamadı, izin sıfırlanıyor');
          await _resetPermission();
          return false;
        }
      } catch (e) {
        print('Drive izni kontrol hatası: $e');
        await _resetPermission();
        return false;
      }
    } else {
      _hasPermission = false;
      print('Drive izni daha önce verilmemiş');
      return false;
    }
  }

  // İzni sıfırlama helper metodu
  Future<void> _resetPermission() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('drive_permission', false);
    _hasPermission = false;
    _driveApi = null;
  }

  // Drive API'yi kurma - Geliştirilmiş hata yönetimi
  Future<void> _setupDriveApi(GoogleSignInAccount account) async {
    try {
      final authentication = await account.authentication;

      if (authentication.accessToken == null) {
        throw Exception('Access token alınamadı');
      }

      final credentials = AccessCredentials(
        AccessToken(
          'Bearer',
          authentication.accessToken!,
          DateTime.now().add(const Duration(hours: 1)).toUtc(),
        ),
        authentication.idToken,
        ['https://www.googleapis.com/auth/drive.file'],
      );

      final client = authenticatedClient(http.Client(), credentials);
      _driveApi = drive.DriveApi(client);
      print('Drive API başarıyla kuruldu - User: ${account.email}');
    } catch (e) {
      print('Drive API kurulum hatası: $e');
      throw Exception('Drive API kurulamadı: $e');
    }
  }

  // Drive izni isteme - Mevcut Google hesabını kullan
  Future<bool> requestDrivePermission() async {
    await _initializeService();

    print('Drive izni isteniyor...');

    try {
      // Önce mevcut giriş durumunu kontrol et
      bool isSignedIn = await _googleSignIn!.isSignedIn();
      GoogleSignInAccount? account;

      if (isSignedIn) {
        account = _googleSignIn!.currentUser;
        print('Mevcut Google hesabı kullanılıyor: ${account?.email}');
      }

      // Eğer hesap yoksa veya geçersizse yeni giriş iste
      if (account == null) {
        print('Yeni Google hesabı girişi isteniyor...');
        account = await _googleSignIn!.signIn();

        if (account == null) {
          print('Kullanıcı giriş yapmayı iptal etti');
          return false;
        }
      }

      print('Google hesabı ile giriş yapıldı: ${account.email}');

      // Drive API'yi kur
      await _setupDriveApi(account);

      // Test için basit bir Drive API çağrısı yap
      await _testDriveAccess();

      // İzni kalıcı olarak kaydet
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('drive_permission', true);
      _hasPermission = true;

      print('Drive izni verildi ve kaydedildi');
      return true;
    } catch (e) {
      print('Drive izni alma hatası: $e');
      await _resetPermission();
      return false;
    }
  }

  // Drive erişimini test et
  Future<void> _testDriveAccess() async {
    if (_driveApi == null) {
      throw Exception('Drive API başlatılmamış');
    }

    try {
      // Basit bir about call yaparak Drive erişimini test et
      final about = await _driveApi!.about.get($fields: 'user');
      print('Drive erişimi test edildi - User: ${about.user?.emailAddress}');
    } catch (e) {
      print('Drive erişim testi başarısız: $e');
      throw Exception('Drive erişimi sağlanamadı: $e');
    }
  }

  // Fotoğrafı Drive'a yükleme - Geliştirilmiş hata yönetimi
  Future<bool> uploadImageToDrive(File imageFile, String fileName) async {
    if (!_hasPermission) {
      print('Drive izni yok');
      return false;
    }

    if (_driveApi == null) {
      print('Drive API hazır değil, yeniden başlatılıyor...');
      final hasPermission = await checkDrivePermission();
      if (!hasPermission) {
        print('Drive API yeniden başlatılamadı');
        return false;
      }
    }

    try {
      print('Dosya yükleniyor: $fileName (${imageFile.lengthSync()} bytes)');

      final driveFile = drive.File();
      driveFile.name = fileName;
      driveFile.parents = ['appDataFolder']; // Uygulamaya özel klasör kullan

      final media = drive.Media(imageFile.openRead(), imageFile.lengthSync());

      final result = await _driveApi!.files.create(
        driveFile,
        uploadMedia: media,
      );

      print(
        'Dosya başarıyla yüklendi - ID: ${result.id}, Name: ${result.name}',
      );
      return true;
    } catch (e) {
      print('Drive yükleme hatası: $e');

      // Token süresi dolmuşsa yenile
      if (e.toString().contains('401') ||
          e.toString().contains('Invalid Credentials')) {
        print('Token yenilenmeye çalışılıyor...');
        final renewed = await _renewToken();
        if (renewed) {
          // Tekrar dene
          return uploadImageToDrive(imageFile, fileName);
        }
      }

      return false;
    }
  }

  // Token yenileme
  Future<bool> _renewToken() async {
    try {
      final account = _googleSignIn!.currentUser;
      if (account != null) {
        await _setupDriveApi(account);
        return true;
      }
      return false;
    } catch (e) {
      print('Token yenileme hatası: $e');
      return false;
    }
  }

  // İzni tamamen iptal etme
  Future<void> revokeDrivePermission() async {
    try {
      if (_googleSignIn != null) {
        await _googleSignIn!.signOut();
        await _googleSignIn!.disconnect();
      }

      await _resetPermission();
      print('Drive izni tamamen iptal edildi');
    } catch (e) {
      print('İzin iptal etme hatası: $e');
    }
  }

  // Getter'lar
  bool get hasPermission => _hasPermission;

  Future<bool> get isSignedIn async {
    await _initializeService();
    return await _googleSignIn?.isSignedIn() ?? false;
  }

  Future<String?> get currentUserEmail async {
    await _initializeService();
    final account = _googleSignIn?.currentUser;
    return account?.email;
  }
}
