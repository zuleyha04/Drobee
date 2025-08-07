import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static final FirebaseRemoteConfig _remoteConfig =
      FirebaseRemoteConfig.instance;

  // Remote Config başlangıç ayarları
  static Future<void> init() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ),
    );

    await _remoteConfig.setDefaults(<String, dynamic>{});

    await _remoteConfig.fetchAndActivate();
  }

  // Manuel olarak fetch tetikleme
  static Future<void> forceFetch() async {
    try {
      await _remoteConfig.fetchAndActivate();
    } catch (e) {}
  }

  // Remove.bg API key'leri (5 adet)
  static String get removeBgKey1 => _remoteConfig.getString('removeBgApiKey1');
  static String get removeBgKey2 => _remoteConfig.getString('removeBgApiKey2');
  static String get removeBgKey3 => _remoteConfig.getString('removeBgApiKey3');
  static String get removeBgKey4 => _remoteConfig.getString('removeBgApiKey4');
  static String get removeBgKey5 => _remoteConfig.getString('removeBgApiKey5');

  //  OpenWeatherMap API key
  static String get weatherApiKey => _remoteConfig.getString('weatherApiKey');

  //  FreeImageHost API key
  static String get imageHostApiKey =>
      _remoteConfig.getString('imageHostApiKey');
}
