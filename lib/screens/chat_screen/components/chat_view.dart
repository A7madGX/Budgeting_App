import 'dart:convert';

import 'package:budgeting_app/extensions.dart';
import 'package:budgeting_app/models/base_embedding_model.dart';
import 'package:budgeting_app/models/chat_message.dart';
import 'package:budgeting_app/models/embeddings.dart';
import 'package:budgeting_app/screens/chat_screen/components/chart_renderer.dart';
import 'package:budgeting_app/screens/chat_screen/components/expense_operations_embedding.dart';
import 'package:budgeting_app/screens/chat_screen/components/picked_image_renderer.dart';
import 'package:budgeting_app/screens/chat_screen/state/chat_view_model.dart';
import 'package:budgeting_app/widgets/expenses_count_label.dart';
import 'package:budgeting_app/widgets/gemini_embed_card.dart';
import 'package:budgeting_app/widgets/gemini_logo.dart';
import 'package:budgeting_app/widgets/shimmer_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatViewModel, ChatState>(
      listener: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _controller.animateTo(
            _controller.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
      },
      builder: (context, state) {
        final chatMessages = state.messages;

        return ListView.separated(
          controller: _controller,
          padding: EdgeInsets.all(16),
          itemCount: chatMessages.length,
          separatorBuilder: (context, index) => const SizedBox(height: 24),
          itemBuilder: (context, index) {
            final message = chatMessages[index];

            return message.isUserMessage
                ? UserChatBubble(message: message)
                : GeminiChatBubble(
                  loading: message.isLoading,
                  message: message.message,
                );
          },
        );
      },
    );
  }
}

class UserChatBubble extends StatelessWidget {
  const UserChatBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.7,
      alignment: Alignment.centerRight,
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: context.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Text(
                message.message,
                style: TextStyle(color: context.colorScheme.onPrimaryContainer),
              ),
              if (message.images != null && message.images!.isNotEmpty ||
                  message.expenses != null && message.expenses!.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (message.images != null && message.images!.isNotEmpty)
                      for (final image in message.images!)
                        PickedImageRenderer(image: image),
                    if (message.expenses != null &&
                        message.expenses!.isNotEmpty)
                      ExpensesCountLabel(count: message.expenses!.length),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class GeminiChatBubble extends StatelessWidget {
  const GeminiChatBubble({
    super.key,
    required this.message,
    this.loading = false,
  });

  final String message;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    // final parsedParts = GeminiResponseParser(message).parse();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.0,
      children: [
        GeminiEmbedCard(
          padding: EdgeInsets.zero,
          enableGlowAnimation: loading,
          child: CircleAvatar(
            radius: 15,
            backgroundColor: context.colorScheme.surfaceContainerHigh,
            child: GeminiLogo(enableAnimations: false, size: 17),
          ),
        ),
        if (loading)
          GeminiEmbedCard(
            padding: EdgeInsets.zero,
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 8, vertical: 4) +
                  EdgeInsets.only(right: 4),
              decoration: ShapeDecoration(
                shape: StadiumBorder(),
                color: context.colorScheme.surfaceContainerLow,
              ),
              child: ShimmerAnimated(
                child: Row(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      constraints: BoxConstraints.tight(Size.square(16)),
                      strokeWidth: 1.5,
                      year2023: false,
                    ),
                    Text(
                      message,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: context.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          GptMarkdown(
            message,
            codeBuilder: (context, type, code, closed) {
              final json = jsonDecode(code);
              final parsed = EmbeddingParser(json).parse();
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: switch (parsed) {
                  ExpenseOperations() => ExpenseOperationsRenderer(
                    expenseOperations: parsed.operations,
                  ),
                  Chart() => ChartRenderer(chartData: parsed),
                },
              );
            },
          ),
      ],
    );
  }
}
