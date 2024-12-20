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
    final tempDir = await getTemporaryDirectory();
    final directory = Directory('${tempDir.path}/hydrated_storage');

    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    debugPrint('Using storage directory: ${directory.path}');

    await Hive.initFlutter();
    await Hive.openBox<List<String>>("recentSearchBox");

    final storage = await HydratedStorage.build(
      storageDirectory: directory,
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

// Fallback UI
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
