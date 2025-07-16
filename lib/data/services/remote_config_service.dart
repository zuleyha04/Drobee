import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static final FirebaseRemoteConfig _remoteConfig =
      FirebaseRemoteConfig.instance;

  static Future<void> init() async {
    await _remoteConfig.setDefaults({
      'removeBgApiKey1': '',
      'removeBgApiKey2': '',
      'weatherApiKey': '',
      'imageHostApiKey': '',
    });

    await _remoteConfig.fetchAndActivate();
  }

  static String get removeBgKey1 => _remoteConfig.getString('removeBgApiKey1');
  static String get removeBgKey2 => _remoteConfig.getString('removeBgApiKey2');
  static String get weatherApiKey => _remoteConfig.getString('weatherApiKey');
  static String get imageHostApiKey =>
      _remoteConfig.getString('imageHostApiKey');
}
