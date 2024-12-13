// lib\app\routes\app_router_delegate.dart

import 'package:auto_parts_online/core/utils/app_logger.dart';
import 'package:auto_parts_online/features/home_page/home_page_view.dart';
import 'package:auto_parts_online/features/products_page/products_page_view.dart';
import 'package:flutter/material.dart';
import '../setup_dependencies.dart';
import 'navigation_cubit.dart';
import 'navigation_state.dart';

class AppRouterDelegate extends RouterDelegate<NavigationState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<NavigationState> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final NavigationCubit navigationCubit;

  AppRouterDelegate(this.navigationCubit)
      : navigatorKey = GlobalKey<NavigatorState>() {
    navigationCubit.stream.listen((state) {
      notifyListeners(); // Ensure updates propagate
    });
  }

  @override
  NavigationState? get currentConfiguration => navigationCubit.state;

  @override
  Widget build(BuildContext context) {
    final logger = getIt<ILogger>();
    logger.debug('Navigator Rebuilding with State: ${navigationCubit.state}');

    final pages = <Page>[
      if (navigationCubit.state is NavigationHomePageState)
        const MaterialPage(child: HomePageView(), name: 'HomePage'),
      if (navigationCubit.state is NavigationProductPageState)
        const MaterialPage(child: ProductsPageView(), name: 'ProductsPage'),
    ];

    logger.debug('Pages List: $pages');
    return Navigator(
      key: navigatorKey,
      pages: pages,
      onDidRemovePage: (_) {
        logger.debug('Pop Page Triggered');

        if (navigationCubit.state is NavigationProductPageState) {
          navigationCubit.goToHomePage();
        }
      },
    );
  }

  @override
  Future<void> setNewRoutePath(NavigationState configuration) async {
    if (configuration is NavigationHomePageState) {
      navigationCubit.goToHomePage();
    } else if (configuration is NavigationProductPageState) {
      navigationCubit.goToProductPage();
    }
  }
}
