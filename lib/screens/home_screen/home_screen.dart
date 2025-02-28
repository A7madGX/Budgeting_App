import 'package:budgeting_app/screens/chat_screen/chat_screen.dart';
import 'package:budgeting_app/screens/expenses_screen/expenses_screen.dart';
import 'package:budgeting_app/screens/settings_screen/settings_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    const screens = [ExpensesScreen(), SettingsScreen()];
    return NavigationController(
      goToChatScreen: _goToChatScreen,
      goToHomeScreen: _goToHomeScreen,
      child: PageView(
        controller: _pageController,

        children: [
          Scaffold(
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: screens[_currentIndex],
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.attach_money_rounded),
                  label: 'Expenses',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_rounded),
                  label: 'Settings',
                ),
              ],
            ),
          ),
          ChatScreen(),
        ],
      ),
    );
  }

  void _goToChatScreen() {
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCirc,
    );
  }

  void _goToHomeScreen() {
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCirc,
    );
  }
}

class NavigationController extends InheritedWidget {
  final void Function() goToChatScreen;
  final void Function() goToHomeScreen;

  const NavigationController({
    super.key,
    required super.child,
    required this.goToChatScreen,
    required this.goToHomeScreen,
  });

  static NavigationController of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NavigationController>()!;
  }

  @override
  bool updateShouldNotify(covariant NavigationController oldWidget) {
    return false;
  }
}
