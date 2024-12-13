// lib\app\routes\app_router_delegate.dart

import 'package:auto_parts_online/features/home_page/home_page_view.dart';
import 'package:auto_parts_online/features/products_page/products_page_view.dart';
import 'package:flutter/material.dart';
import 'navigation_bloc.dart';
import 'navigation_state.dart';

class AppRouterDelegate extends RouterDelegate<NavigationState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final NavigationCubit navigationCubit;

  AppRouterDelegate(this.navigationCubit)
      : navigatorKey = GlobalKey<NavigatorState>() {
    navigationCubit.stream.listen((state) {
      notifyListeners();
    });
  }

  @override
  NavigationState? get currentConfiguration => navigationCubit.state;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (navigationCubit.state is NavigationHomePageState)
          const MaterialPage(child: HomePageView()),
        if (navigationCubit.state is NavigationProductPageState)
          const MaterialPage(child: ProductsPageView()),
      ],
      onDidRemovePage: (Page<Object?> page) {
        if (page.name == 'ProductsPage') {
          navigationCubit.goToHomePage(); // Example Cubit state update
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
