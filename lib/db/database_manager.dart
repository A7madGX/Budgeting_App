import 'package:budgeting_app/models/expense_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  late final Database _db;

  Future<void> init() async {
    _db = await openDatabase(
      'app_data.db',
      version: 1,
      onCreate: (db, version) {
        db.execute(ExpensesTable.createTable);
      },
    );
  }

  Future<void> insertExpense(Expense expense) async {
    await _db.insert(ExpensesTable.table, expense.toMap());
  }

  Future<List<Expense>> getExpenses({bool ascending = false}) async {
    final orderBy = ascending ? '${ExpensesTable.date} ASC' : '${ExpensesTable.date} DESC';
    final results = await _db.query(ExpensesTable.table, orderBy: orderBy);
    return results.map((e) => Expense.fromMap(e)).toList();
  }

  Future<void> updateExpense(Expense expense) async {
    await _db.update(ExpensesTable.table, expense.toMap(), where: '${ExpensesTable.id} = ?', whereArgs: [expense.id]);
  }

  Future<void> deleteExpense(int id) async {
    await _db.delete(ExpensesTable.table, where: '${ExpensesTable.id} = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> rawQuery(String query) async {
    final results = await _db.rawQuery(query);
    return results;
  }
}

class ExpensesTable {
  static const String table = 'expenses';
  static const String id = 'id';
  static const String name = 'name';
  static const String amount = 'amount';
  static const String category = 'category';
  static const String description = 'description';
  static const String date = 'date';

  static const List<String> columns = [id, name, amount, category, description, date];
  static const List<String> categories = ['Groceries', 'Transport', 'Entertainment', 'Health', 'Dining', 'Utilities', 'Other'];

  static const String createTable = '''
    CREATE $schema
  ''';

  static const String schema = '''
    TABLE: $table (
      $id: INTEGER PRIMARY KEY AUTOINCREMENT,
      $name: TEXT,
      $amount: REAL,
      $category: TEXT,
      $description: TEXT,
      $date: TEXT
    )
  ''';
}
