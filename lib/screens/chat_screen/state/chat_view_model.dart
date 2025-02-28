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

  Future<void> sendMessage(String message, String queryContext) async {
    _addUserMessage(message);
    await _generateAndAddAIResponse(message, queryContext);
  }

  void _addUserMessage(String message) {
    final userMessage = ChatMessage(isUserMessage: true, message: message);
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

  Future<void> _generateAndAddAIResponse(
    String message,
    String queryContext,
  ) async {
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
