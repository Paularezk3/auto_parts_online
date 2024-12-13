import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../core/themes.dart';
import 'routes/app_router_delegate.dart';
import 'routes/navigation_bloc.dart';
import 'routes/navigation_state.dart';

class MyMaterialApp extends StatelessWidget {
  final Locale locale;

  const MyMaterialApp({required this.locale, super.key});

  @override
  Widget build(BuildContext context) {
    // Create the NavigationCubit instance
    final navigationCubit = NavigationCubit();

    // Create the AppRouterDelegate instance
    final appRouterDelegate = AppRouterDelegate(navigationCubit);

    return BlocProvider(
      create: (_) => navigationCubit,
      child: MaterialApp.router(
        locale: locale,
        title: 'Elite Spare Parts',
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: ThemeMode.system,
        routerDelegate: appRouterDelegate,
        routeInformationParser: _AppRouteInformationParser(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}

class _AppRouteInformationParser
    extends RouteInformationParser<NavigationState> {
  @override
  Future<NavigationState> parseRouteInformation(
      RouteInformation routeInformation) async {
    // Default to home page for now; you can expand this to parse specific routes
    return NavigationHomePageState();
  }

  @override
  RouteInformation? restoreRouteInformation(NavigationState configuration) {
    if (configuration is NavigationHomePageState) {
      return const RouteInformation(location: '/home');
    } else if (configuration is NavigationProductPageState) {
      return const RouteInformation(location: '/products');
    }
    return null;
  }
}
