import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String _userIdKey = 'current_user_id';

  // Kullanıcı ID'sini kaydet (giriş yaparken çağırın)
  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  // Mevcut kullanıcı ID'sini al
  static Future<String?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // Kullanıcı çıkışı (ID'yi temizle)
  static Future<void> clearUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
  }

  // Kullanıcı giriş yapmış mı kontrol et
  static Future<bool> isUserLoggedIn() async {
    final userId = await getCurrentUserId();
    return userId != null && userId.isNotEmpty;
  }
}
