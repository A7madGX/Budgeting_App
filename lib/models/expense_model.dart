import 'package:budgeting_app/models/base_embedding_model.dart';

import '../db/database_manager.dart';

class Expense {
  final int? id;
  final double amount;
  final String category;
  final String description;
  final String date;

  Expense({
    this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      ExpensesTable.id: id,
      ExpensesTable.amount: amount,
      ExpensesTable.category: category,
      ExpensesTable.description: description,
      ExpensesTable.date: date,
    };
  }

  // Create Expense from Map
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map[ExpensesTable.id] as int?,
      amount: map[ExpensesTable.amount] as double,
      category: map[ExpensesTable.category] as String,
      description: map[ExpensesTable.description] as String,
      date: map[ExpensesTable.date] as String,
    );
  }

  // Create copy of Expense with optional new values
  Expense copyWith({
    int? id,
    double? amount,
    String? category,
    String? description,
    String? date,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
    );
  }
}

class ExpenseOperation {
  final Expense expense;
  final OperationType type;

  ExpenseOperation({required this.expense, required this.type});

  factory ExpenseOperation.fromMap(Map<String, dynamic> json) {
    return ExpenseOperation(
      expense: Expense.fromMap(json),
      type: OperationType.fromString(json['operationType'] as String),
    );
  }
}

enum OperationType {
  read,
  add,
  update,
  delete;

  static OperationType fromString(String value) {
    switch (value) {
      case 'read':
        return OperationType.read;
      case 'add':
        return OperationType.add;
      case 'update':
        return OperationType.update;
      case 'delete':
        return OperationType.delete;
      default:
        throw ArgumentError('Invalid OperationType value');
    }
  }
}

class ExpenseOperations extends BaseEmbeddingModel {
  final List<ExpenseOperation> operations;

  ExpenseOperations(this.operations);

  factory ExpenseOperations.fromJson(List<Map<String, dynamic>> json) {
    return ExpenseOperations(
      json.map((e) => ExpenseOperation.fromMap(e)).toList(),
    );
  }
}
