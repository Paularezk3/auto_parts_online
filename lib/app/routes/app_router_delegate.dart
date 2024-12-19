// lib\app\routes\app_router_delegate.dart

import 'package:auto_parts_online/core/utils/app_logger.dart';
import 'package:auto_parts_online/features/home/home_page_view.dart';
import 'package:auto_parts_online/features/products/products_page_view.dart';
import 'package:auto_parts_online/features/search/search_page_view.dart';
import 'package:flutter/material.dart';
import '../../features/account/account_page_view.dart';
import '../../features/cart/cart_page_view.dart';
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
    navigationCubit.stream.listen((_) => notifyListeners());
  }

  @override
  NavigationState? get currentConfiguration => navigationCubit.state;

  @override
  Widget build(BuildContext context) {
    final logger = getIt<ILogger>();
    logger.debug('Navigator Rebuilding with State: ${navigationCubit.state}');

    final page = _mapStateToPage(navigationCubit.state);

    logger.debug('Current Page: $page');
    return Navigator(
      key: navigatorKey,
      pages: [page],
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        logger.debug('Pop Page Triggered');
        navigationCubit.navigateTo(NavigationHomePageState());
        return true;
      },
    );
  }

  Page _mapStateToPage(NavigationState state) {
    switch (state.runtimeType) {
      case const (NavigationProductPageState):
        return const MaterialPage(
            child: ProductsPageView(), name: 'ProductsPage');
      case const (NavigationCartPageState):
        return const MaterialPage(child: CartPageView(), name: 'CartPage');
      case const (NavigationAccountPageState):
        return const MaterialPage(
            child: AccountPageView(), name: 'AccountPage');
      case const (NavigationSearchPageState):
        return const MaterialPage(child: SearchPageView(), name: 'SearchPage');
      default:
        return const MaterialPage(child: HomePageView(), name: 'HomePage');
    }
  }

  @override
  Future<void> setNewRoutePath(NavigationState configuration) async {
    navigationCubit.navigateTo(configuration);
  }
}
