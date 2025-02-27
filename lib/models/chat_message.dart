class ChatMessage {
  final bool isUserMessage;
  final String message;
  final String? context;
  final bool isLoading;

  const ChatMessage({
    this.isUserMessage = true,
    required this.message,
    this.context,
    this.isLoading = false,
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
