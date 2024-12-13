// lib\app\setup_dependencies.dart

import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../core/utils/app_logger.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<ILogger>(() => AppLogger(logger: Logger()));
}
