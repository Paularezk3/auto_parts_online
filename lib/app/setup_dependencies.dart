// lib\app\setup_dependencies.dart

import 'package:auto_parts_online/features/home/mock_home_page_service.dart';
import 'package:auto_parts_online/features/search/mock_search_page_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../core/utils/app_logger.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<ILogger>(() => AppLogger(logger: Logger()));
  getIt
      .registerLazySingleton<IMockHomePageService>(() => MockHomePageService());
  getIt.registerLazySingleton<IMockSearchPageService>(
      () => MockSearchPageService());
  getIt.registerSingleton<GlobalKey<NavigatorState>>(
      GlobalKey<NavigatorState>());
}
