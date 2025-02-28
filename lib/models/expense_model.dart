import '../db/database_manager.dart';

class Expense {
  final int? id;
  final bool positive;
  final num amount;
  final String category;
  final String description;
  final String date;

  Expense({
    this.id,
    required this.positive,
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
      ExpensesTable.positive: positive ? 1 : 0,
    };
  }

  // Create Expense from Map
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map[ExpensesTable.id] as int?,
      positive: map[ExpensesTable.positive] as int == 1,
      amount: map[ExpensesTable.amount] as num,
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
    bool? positive,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
      positive: positive ?? this.positive,
    );
  }
}
