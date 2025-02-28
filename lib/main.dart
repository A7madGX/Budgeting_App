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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Brightness _theme = Brightness.light;
  Color _primaryColor = Colors.blue;

  void _setTheme(Brightness theme) {
    setState(() {
      _theme = theme;
    });
  }

  void _setPrimaryColor(Color color) {
    setState(() {
      _primaryColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: _theme,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ExpensesCrudRequestsCubit()),
        BlocProvider(create: (context) => ChatViewModel()),
      ],
      child: ThemeController(
        theme: _theme,
        setTheme: _setTheme,
        setPrimaryColor: _setPrimaryColor,
        child: MaterialApp(
          theme: ThemeData.from(colorScheme: colorScheme),
          home: HomeScreen(),
        ),
      ),
    );
  }
}

class ThemeController extends InheritedWidget {
  final Brightness theme;
  final void Function(Brightness) setTheme;
  final void Function(Color) setPrimaryColor;

  const ThemeController({
    super.key,
    required this.theme,
    required this.setTheme,
    required this.setPrimaryColor,
    required super.child,
  });

  static ThemeController of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeController>()!;
  }

  @override
  bool updateShouldNotify(covariant ThemeController oldWidget) {
    return theme != oldWidget.theme;
  }
}
