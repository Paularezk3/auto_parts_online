// lib\app\my_material_app.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../core/themes.dart';
import '../core/utils/app_logger.dart';
import 'routes/app_router_delegate.dart';
import 'routes/navigation_cubit.dart';
import 'routes/navigation_state.dart';
import 'setup_dependencies.dart';

class MyMaterialApp extends StatelessWidget {
  final Locale locale;

  const MyMaterialApp({required this.locale, super.key});

  @override
  Widget build(BuildContext context) {
    final logger = getIt<ILogger>();
    return BlocProvider(
      create: (_) => NavigationCubit(logger: logger),
      child: Builder(builder: (context) {
        final navigationCubit = context.read<NavigationCubit>();
        final appRouterDelegate = AppRouterDelegate(navigationCubit);

        return MaterialApp.router(
          locale: locale,
          title: 'Elite Spare Parts',
          theme: AppThemes.lightTheme,
          themeMode: ThemeMode.light,
          routerDelegate: appRouterDelegate,
          routeInformationParser: _AppRouteInformationParser(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
        );
      }),
    );
  }
}

class _AppRouteInformationParser
    extends RouteInformationParser<NavigationState> {
  @override
  Future<NavigationState> parseRouteInformation(
      RouteInformation routeInformation) async {
    return NavigationHomePageState();
  }

  @override
  RouteInformation? restoreRouteInformation(NavigationState configuration) {
    if (configuration is NavigationHomePageState) {
      return RouteInformation(uri: Uri.parse('/home'));
    } else if (configuration is NavigationProductPageState) {
      return RouteInformation(uri: Uri.parse('/products'));
    } else if (configuration is NavigationAccountPageState) {
      return RouteInformation(uri: Uri.parse('/account'));
    } else if (configuration is NavigationCartPageState) {
      return RouteInformation(uri: Uri.parse('/cart'));
    } else if (configuration is NavigationSearchPageState) {
      return RouteInformation(uri: Uri.parse('/searchpage'));
    } else if (configuration is NavigationProductDetailsPageState) {
      return RouteInformation(uri: Uri.parse('/productDetailsPage'));
    } else if (configuration is NavigationCheckoutPageState) {
      return RouteInformation(uri: Uri.parse('/checkoutPage'));
    } else if (configuration is NavigationOnlinePaymentPageState) {
      return RouteInformation(uri: Uri.parse('/onlinePaymentPage'));
    } else if (configuration is NavigationOrderPlacedSuccessfullyState) {
      return RouteInformation(uri: Uri.parse('/orderPlaccedSuccessfully'));
    }
    return null;
  }
}

class CustomPageTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
