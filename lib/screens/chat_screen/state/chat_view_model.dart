import 'dart:io';

import 'package:budgeting_app/main.dart';
import 'package:budgeting_app/models/chat_message.dart';
import 'package:budgeting_app/models/expense_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_state.dart';
part 'chat_view_model.freezed.dart';

class ChatViewModel extends Cubit<ChatState> {
  ChatViewModel({List<ChatMessage>? messages, List<Expense>? expenses})
    : super(ChatState.initial(messages: messages, selectedExpenses: expenses));

  Future<void> sendMessage({
    required String message,
    required String queryContext,
    required List<File>? images,
  }) async {
    _addUserMessage(message: message, images: images);
    await _generateAndAddAIResponse(
      message: message,
      queryContext: queryContext,
      images: images,
    );
  }

  void _addUserMessage({required String message, List<File>? images}) {
    final userMessage = ChatMessage(
      isUserMessage: true,
      message: message,
      images: images,
      expenses:
          state.selectedExpenses.isNotEmpty ? state.selectedExpenses : null,
    );
    final loadingMessage = ChatMessage(
      isUserMessage: false,
      message: 'Gemini is cooking 🥘🔥',
      isLoading: true,
    );
    emit(
      state.copyWith(
        sendMessageStatus: SendMessageStatus.loading,
        messages: [...state.messages, userMessage, loadingMessage],
      ),
    );
  }

  Future<void> _generateAndAddAIResponse({
    required String message,
    required String queryContext,
    List<File>? images,
  }) async {
    final context =
        'Context: ${queryContext.isNotEmpty ? queryContext : 'None'}';
    final numberedChatLog = state.messages
        .mapIndexed(
          (index, e) =>
              'Message: ${index + 1} by ${e.isUserMessage ? 'User' : 'Gemini'}: ${e.message}',
        )
        .join('\n');
    final pastChatHistory = 'Chat History:\n$numberedChatLog';
    try {
      final response = await geminiServices.prompt(
        query: '$message\n$context\n$pastChatHistory',
        images: images,
      );
      _addAISuccessResponse(response);
    } catch (e) {
      _addAIErrorResponse();
    }
  }

  void _addAISuccessResponse(String responseMessage) {
    final aiMessage = ChatMessage(
      isUserMessage: false,
      message: responseMessage,
    );
    emit(
      state.copyWith(
        sendMessageStatus: SendMessageStatus.success,
        messages: [
          ...state.messages.sublist(0, state.messages.length - 1),
          aiMessage,
        ],
      ),
    );
  }

  void _addAIErrorResponse() {
    final errorMessage = ChatMessage(
      isUserMessage: false,
      message: 'Sorry, I am unable to process your request at the moment.',
    );
    emit(
      state.copyWith(
        sendMessageStatus: SendMessageStatus.error,
        messages: [
          ...state.messages.sublist(0, state.messages.length - 1),
          errorMessage,
        ],
      ),
    );
  }

  void toggleExpenseSelection(Expense expense) {
    final selectedExpenses = state.selectedExpenses;
    final newSelectedExpenses =
        selectedExpenses.contains(expense)
            ? selectedExpenses.where((e) => e != expense).toList()
            : [...selectedExpenses, expense];
    emit(state.copyWith(selectedExpenses: newSelectedExpenses));
  }

  void deselectAllExpenses() {
    emit(state.copyWith(selectedExpenses: []));
  }
}
