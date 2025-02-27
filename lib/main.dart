import 'package:budgeting_app/db/database_manager.dart';
import 'package:budgeting_app/services/gemini/gemini_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

final dbManager = DatabaseManager();
final geminiServices = GeminiServices();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dbManager.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(primary: Colors.blue, seedColor: Colors.blue);

    return MaterialApp(theme: ThemeData.from(colorScheme: colorScheme), home: const HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('Welcome to the Budgeting App!')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final res = await geminiServices.prompt(query: 'Today I bought apples for 20, and took a bus for 15, please add these expenses.');

          debugPrint('Gemini Response: $res');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
