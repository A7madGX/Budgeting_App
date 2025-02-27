import '../db/database_manager.dart';

class Expense {
  final int? id;
  final String name;
  final double amount;
  final String category;
  final String description;
  final String date;

  Expense({this.id, required this.name, required this.amount, required this.category, required this.description, required this.date});

  Map<String, dynamic> toMap() {
    return {
      ExpensesTable.id: id,
      ExpensesTable.name: name,
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
      name: map[ExpensesTable.name] as String,
      amount: map[ExpensesTable.amount] as double,
      category: map[ExpensesTable.category] as String,
      description: map[ExpensesTable.description] as String,
      date: map[ExpensesTable.date] as String,
    );
  }

  // Create copy of Expense with optional new values
  Expense copyWith({int? id, String? name, double? amount, String? category, String? description, String? date}) {
    return Expense(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
    );
  }
}
