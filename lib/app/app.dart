// lib\app\app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/utils/locale_service.dart';
import '../features/home/bloc/home_page_bloc.dart';

import '../features/products/bloc/products_page_bloc.dart';
import 'my_material_app.dart';

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

    if (_locale == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomePageBloc()),
        BlocProvider(create: (_) => ProductsPageBloc())
        // Future BLoC providers can be added here
      ],
      child: MyMaterialApp(locale: _locale!),
    );
  }
}
