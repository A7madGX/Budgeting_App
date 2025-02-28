import 'package:budgeting_app/models/embeddings.dart';

class EmbeddingParser {
  final Map<String, dynamic> json;

  const EmbeddingParser(this.json);

  static const String chart = 'chart';
  static const String expenseOperation = 'expenseOperation';
  static const String accountOperation = 'accountOperation';

  BaseEmbeddingModel parse() {
    final data = json['data'];
    return switch (json['type']) {
      chart => Chart.fromJson(data),
      expenseOperation => ExpenseOperations.fromJson(data),
      accountOperation => AccountOperations.fromJson(data),
      _ => throw ArgumentError('Invalid Embedding Type: ${json['type']}'),
    };
  }
}
