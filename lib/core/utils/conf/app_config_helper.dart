import 'package:hive/hive.dart';

import 'app_config.dart';

class AppConfigHelper {
  static const String _boxName = 'appConfigBox';

  late Box<AppConfig> _box;

  Future<void> init() async {
    _box = await Hive.openBox<AppConfig>(_boxName);
  }

  AppConfig getConfig() {
    // Return the stored AppConfig or default values if not set
    return _box.get('config') ??
        AppConfig(
            cartValueLimit: 1000.0,
            maxOrderQuantity: 10,
            apiUrl: 'https://api.example.com');
  }

  Future<void> updateConfig(AppConfig config) async {
    await _box.put('config', config);
  }
}
