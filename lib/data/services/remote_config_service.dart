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

  static String get removeBgKey1 => _remoteConfig.getString('removeBgApiKey1');
  static String get removeBgKey2 => _remoteConfig.getString('removeBgApiKey2');
  static String get weatherApiKey => _remoteConfig.getString('weatherApiKey');
  static String get imageHostApiKey =>
      _remoteConfig.getString('imageHostApiKey');
}
