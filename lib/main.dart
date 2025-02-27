import 'package:budgeting_app/db/database_manager.dart';
import 'package:budgeting_app/screens/chat_screen/state/chat_view_model.dart';
import 'package:budgeting_app/screens/home_screen/home_screen.dart';
import 'package:budgeting_app/services/gemini/gemini_services.dart';
import 'package:budgeting_app/states/expenses_crud_requests.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ExpensesCrudRequestsCubit()),
        BlocProvider(create: (context) => ChatViewModel()),
      ],
      child: MaterialApp(
        theme: ThemeData.from(colorScheme: colorScheme),
        home: HomeScreen(),
      ),
    );
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
          final res = await geminiServices.prompt(
            query:
                'Today I bought apples for 20, and took a bus for 15, please add these expenses.',
          );

          debugPrint('Gemini Response: $res');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
