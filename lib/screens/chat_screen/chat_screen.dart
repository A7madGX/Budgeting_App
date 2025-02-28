import 'package:budgeting_app/extensions.dart';
import 'package:budgeting_app/screens/chat_screen/components/chat_view.dart';
import 'package:budgeting_app/screens/chat_screen/components/input_section.dart';
import 'package:budgeting_app/screens/home_screen/home_screen.dart';
import 'package:budgeting_app/widgets/gemini_logo.dart';
import 'package:budgeting_app/widgets/shimmer_animated.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(
          onPressed: () {
            NavigationController.of(context).goToHomeScreen();
          },
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            ShimmerAnimated(child: const GeminiLogo(size: 24)),
            Row(
              children: [
                Text('Chat with ', style: context.textTheme.titleLarge),
                ShimmerAnimated(
                  child: Text(
                    'Gemini',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: ChatView(),
      bottomNavigationBar: InputSection(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
