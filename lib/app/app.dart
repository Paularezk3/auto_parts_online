// lib\app\app.dart

import 'package:auto_parts_online/features/home_page/view/home_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/themes.dart';
import '../features/home_page/bloc/home_page_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomePageBloc(),
        ),
        // Add other BLoCs here
      ],
      child: MaterialApp(
        title: 'Elite Spare Parts',
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomePageView(),
      ),
    );
  }
}
