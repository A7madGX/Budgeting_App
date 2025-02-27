import 'package:budgeting_app/extensions.dart';
import 'package:budgeting_app/screens/chat_screen/components/chat_view.dart';
import 'package:budgeting_app/screens/chat_screen/components/input_section.dart';
import 'package:budgeting_app/screens/chat_screen/state/chat_view_model.dart';
import 'package:budgeting_app/widgets/gemini_logo.dart';
import 'package:budgeting_app/widgets/shimmer_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatViewModel(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
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
      ),
    );
  }
}
