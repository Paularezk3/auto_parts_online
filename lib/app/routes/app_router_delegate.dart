// lib\app\routes\app_router_delegate.dart

import 'package:auto_parts_online/features/checkout/checkout_page_view.dart';
import 'package:flutter/material.dart';
import '../../core/utils/app_logger.dart';
import '../../features/home/home_page_view.dart';
import '../../features/product_details_page/product_details_page_view.dart';
import '../../features/products/products_page_view.dart';
import '../../features/search/search_page_view.dart';
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
  NavigationState? get currentConfiguration => navigationCubit.currentState;

  @override
  Widget build(BuildContext context) {
    final logger = getIt<ILogger>();
    logger.debug(
        'Navigator Rebuilding with State: ${navigationCubit.currentState}',
        StackTrace.empty);

    return PopScope(
      onPopInvokedWithResult: _handleBackButtonPress,
      canPop: true,
      child: Navigator(
        key: navigatorKey,
        pages: navigationCubit.state
            .map((state) => _mapStateToPage(state))
            .toList(),
        onPopPage: (route, result) {
          if (!route.didPop(result)) return false;
          return _navigateBack();
        },
      ),
    );
  }

  void _handleBackButtonPress(bool didPop, dynamic result) async {
    final logger = getIt<ILogger>();
    if (navigationCubit.state.length == 1) {
      // Exit app if already on the home page
      if (didPop) {
        logger.debug('Back button pressed on Home Page - exiting app',
            StackTrace.current);
      }
    } else {
      // Navigate to home page or previous state
      logger.debug(
          'Back button pressed - navigating to Home Page', StackTrace.empty);
      if (navigationCubit.currentState is NavigationSearchPageState) {
        navigationCubit.navigateTo(NavigationHomePageState());
      }
      navigationCubit.pop();
    }
  }

  bool _navigateBack() {
    final logger = getIt<ILogger>();
    if (navigationCubit.state.length > 1) {
      navigationCubit.pop();
      return true;
    } else {
      logger.debug('Already at base state, cannot pop', StackTrace.empty);
      return false;
    }
  }

  Page _mapStateToPage(NavigationState state) {
    switch (state.runtimeType) {
      case const (NavigationProductPageState):
        return const MaterialPage(
          child: ProductsPageView(),
          name: 'ProductsPage',
        );

      case const (NavigationProductDetailsPageState):
        final productId =
            (state as NavigationProductDetailsPageState).productId;
        return MaterialPage(
          child: ProductDetailsPageView(productId: productId),
          name: 'ProductDetailsPage',
        );

      case const (NavigationCheckoutPageState):
        final productId = (state as NavigationCheckoutPageState).items;
        return MaterialPage(
          child: CheckoutPageView(cartItems: productId),
          name: 'ProductDetailsPage',
        );

      case const (NavigationCartPageState):
        return const MaterialPage(child: CartPageView(), name: 'CartPage');

      case const (NavigationAccountPageState):
        return const MaterialPage(
          child: AccountPageView(),
          name: 'AccountPage',
        );

      case const (NavigationSearchPageState):
        return const MaterialPage(
          child: SearchPageView(),
          name: 'SearchPage',
        );

      default:
        return const MaterialPage(
          child: HomePageView(),
          name: 'HomePage',
        );
    }
  }

  @override
  Future<void> setNewRoutePath(NavigationState configuration) async {
    navigationCubit.navigateTo(configuration);
  }
}
