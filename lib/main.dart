// lib\main.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'app/app.dart';
import 'app/setup_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final appDir = await getTemporaryDirectory();
    final hydratedDir = Directory('${appDir.path}/hydrated_storage');

    if (!hydratedDir.existsSync()) {
      hydratedDir.createSync(recursive: true);
    }

    debugPrint('Using storage directory: ${hydratedDir.path}');

    await Hive.initFlutter(appDir.path);
    await Hive.openBox<List<String>>("recentSearchBox");

    final storage = await HydratedStorage.build(
      storageDirectory: hydratedDir,
    );

    HydratedBloc.storage = storage;

    setupDependencies();
    runApp(const MyApp());
  } catch (e, stackTrace) {
    debugPrint('Failed to initialize HydratedStorage: $e');
    debugPrint('Stack trace: $stackTrace');

    runApp(const ErrorApp(
        message: 'Initialization failed. Please restart the app.'));
  }
}

/// Fallback UI for the runApp
class ErrorApp extends StatelessWidget {
  final String message;

  const ErrorApp({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            message,
            style: const TextStyle(fontSize: 18, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
