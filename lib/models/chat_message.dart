import 'dart:io';

import 'package:budgeting_app/models/expense_model.dart';

class ChatMessage {
  final bool isUserMessage;
  final String message;
  final String? context;
  final bool isLoading;
  final List<File>? images;
  final List<Expense>? expenses;

  const ChatMessage({
    this.isUserMessage = true,
    required this.message,
    this.context,
    this.isLoading = false,
    this.images,
    this.expenses,
  });

  ChatMessage copyWith({
    bool? isUserMessage,
    String? message,
    String? context,
    bool? isLoading,
  }) {
    return ChatMessage(
      isUserMessage: isUserMessage ?? this.isUserMessage,
      message: message ?? this.message,
      context: context ?? this.context,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
