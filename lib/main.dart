import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quizzify_app/firebase_options.dart';
import 'package:quizzify_app/models/db_schemas.dart';
import 'core/router.dart';
import 'theme/app_theme.dart';
import 'services/storage_service.dart';
import 'providers/service_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Isar
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(DbSchemas.allSchemas, directory: dir.path);

  // Initialize storage
  final storageService = StorageService(isar);

  runApp(
    ProviderScope(
      overrides: [storageServiceProvider.overrideWithValue(storageService)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Quizify AI',
      routerConfig: router,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
