// lib\app\setup_dependencies.dart

import 'package:auto_parts_online/features/checkout/mock_checkout_page_service.dart';
import 'package:auto_parts_online/features/home/mock_home_page_service.dart';
import 'package:auto_parts_online/features/product_details_page/mock_product_details_page_service.dart';
import 'package:auto_parts_online/features/products/mock_products_page_service.dart';
import 'package:auto_parts_online/features/search/mock_search_page_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../core/cubits/recent_search_cubit.dart';
import '../core/utils/conf/app_config_helper.dart';
import '../core/utils/app_logger.dart';
import '../core/utils/hive_helper.dart';
import '../features/cart/mock_cart_page_service.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<ILogger>(() => AppLogger(logger: Logger()));

  getIt
      .registerLazySingleton<IMockHomePageService>(() => MockHomePageService());
  getIt.registerLazySingleton<IMockSearchPageService>(
      () => MockSearchPageService());
  getIt.registerLazySingleton<IMockProductsPageService>(
      () => MockProductsPageService());
  getIt.registerLazySingleton<IMockProductDetailsPageService>(
      () => MockProductDetailsPageService());
  getIt
      .registerLazySingleton<IMockCartPageService>(() => MockCartPageService());
  getIt.registerLazySingleton<IMockCheckoutPageService>(
      () => MockCheckoutPageService());

  getIt.registerLazySingleton<HiveHelper>(() {
    final helper = HiveHelper(getIt<ILogger>());
    helper.init(); // Initialize the Hive box during registration
    return helper;
  });
  getIt.registerFactory(() => RecentSearchCubit(getIt<HiveHelper>()));

  getIt.registerSingleton<GlobalKey<NavigatorState>>(
      GlobalKey<NavigatorState>());

  getIt.registerLazySingleton<AppConfigHelper>(() {
    final helper = AppConfigHelper();
    helper.init(); // Initialize the Hive box during registration
    return helper;
  });
}
