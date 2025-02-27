part of 'chat_view_model.dart';

@freezed
abstract class ChatState with _$ChatState {
  const ChatState._();

  const factory ChatState({
    required SendMessageStatus sendMessageStatus,
    required List<ChatMessage> messages,
    required List<Expense> selectedExpenses,
  }) = _ChatState;

  factory ChatState.initial({
    List<ChatMessage>? messages,
    List<Expense>? selectedExpenses,
  }) => ChatState(
    sendMessageStatus: SendMessageStatus.intial,
    messages: messages ?? [],
    selectedExpenses: selectedExpenses ?? [],
  );
}

enum SendMessageStatus { intial, loading, success, error }
