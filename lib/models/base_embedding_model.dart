import 'package:budgeting_app/models/chart_model.dart';
import 'package:budgeting_app/models/expense_model.dart';

class EmbeddingParser {
  final Map<String, dynamic> json;

  const EmbeddingParser(this.json);

  static const String chart = 'chart';
  static const String expenseOperation = 'expenseOperation';

  BaseEmbeddingModel parse() {
    final data = json['data'];
    return switch (json['type']) {
      chart => Chart.fromJson(data),
      expenseOperation => ExpenseOperations.fromJson(data),
      _ => throw ArgumentError('Invalid Embedding Type: ${json['type']}'),
    };
  }
}

abstract class BaseEmbeddingModel {}
