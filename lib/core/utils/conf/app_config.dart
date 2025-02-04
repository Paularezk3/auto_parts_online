// lib\core\utils\config_service.dart

import 'package:hive/hive.dart';

part 'app_config.g.dart'; // Hive will generate this file after code generation

@HiveType(typeId: 0) // Unique typeId for this model
class AppConfig extends HiveObject {
  @HiveField(0)
  double cartValueLimit;

  @HiveField(1)
  int maxOrderQuantity;

  @HiveField(2)
  String apiUrl;

  AppConfig({
    required this.cartValueLimit,
    required this.maxOrderQuantity,
    required this.apiUrl,
  });
}
