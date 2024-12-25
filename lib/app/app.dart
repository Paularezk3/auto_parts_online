// lib\app\app.dart
import 'package:auto_parts_online/features/cart/bloc/cart_page_bloc.dart';
import 'package:auto_parts_online/features/product_details_page/bloc/product_details_page_bloc.dart';
import 'package:auto_parts_online/features/search/bloc/search_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/utils/locale_service.dart';
import '../features/cart/app_level_cubit/cart_cubit.dart';
import '../features/home/bloc/home_page_bloc.dart';

import '../features/products/bloc/products_page_bloc.dart';
import 'my_material_app.dart';
import 'setup_dependencies.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    LocaleService().getDeviceLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // If locale is not yet initialized, show a loading screen
    final navigatorKey = getIt<GlobalKey<NavigatorState>>();
    if (_locale == null) {
      return MaterialApp(
        navigatorKey: navigatorKey,
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomePageBloc()),
        BlocProvider(create: (_) => ProductsPageBloc()),
        BlocProvider(
          create: (_) => SearchPageBloc(),
        ),
        BlocProvider(create: (_) => ProductDetailsPageBloc()),
        BlocProvider(create: (_) => CartPageBloc()),
        BlocProvider(create: (_) => CartCubit()),
        // Future BLoC providers can be added here
      ],
      child: MyMaterialApp(locale: _locale!),
    );
  }
}
