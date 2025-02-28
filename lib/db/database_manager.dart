import 'package:budgeting_app/constants.dart';
import 'package:budgeting_app/models/account_model.dart';
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
        db.execute(AccountTable.createTable);
      },
    );
  }

  // Expense operations
  Future<void> insertExpense(Expense expense) async {
    await _db.insert(ExpensesTable.table, expense.toMap());
  }

  Future<List<Expense>> getExpenses({bool ascending = false}) async {
    final results = await _db.query(ExpensesTable.table);
    final expenses = results.map((e) => Expense.fromMap(e)).toList();

    if (ascending) {
      expenses.sort(
        (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)),
      );
    } else {
      expenses.sort(
        (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)),
      );
    }

    return expenses;
  }

  Future<void> updateExpense(Expense expense) async {
    await _db.update(
      ExpensesTable.table,
      expense.toMap(),
      where: '${ExpensesTable.id} = ?',
      whereArgs: [expense.id],
    );
  }

  Future<void> deleteExpense(int id) async {
    await _db.delete(
      ExpensesTable.table,
      where: '${ExpensesTable.id} = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertExpenses(List<Expense> expenses) async {
    final batch = _db.batch();
    for (final expense in expenses) {
      batch.insert(ExpensesTable.table, expense.toMap());
    }
    await batch.commit(noResult: true);
  }

  Future<void> deleteAllExpenses() async {
    await _db.delete(ExpensesTable.table);
  }

  // Account operations
  Future<void> insertAccount(Account account) async {
    await _db.insert(AccountTable.table, account.toMap());
  }

  Future<List<Account>> getAccounts() async {
    final results = await _db.query(AccountTable.table);
    return results.map((e) => Account.fromMap(e)).toList();
  }

  Future<void> updateAccount(Account account) async {
    await _db.update(
      AccountTable.table,
      account.toMap(),
      where: '${AccountTable.id} = ?',
      whereArgs: [account.id],
    );
  }

  Future<void> deleteAccount(int id) async {
    await _db.delete(
      AccountTable.table,
      where: '${AccountTable.id} = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertAccounts(List<Account> accounts) async {
    final batch = _db.batch();
    for (final account in accounts) {
      batch.insert(AccountTable.table, account.toMap());
    }
    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> rawQuery(String query) async {
    final results = await _db.rawQuery(query);
    return results;
  }
}

class ExpensesTable {
  static const String table = 'expenses';
  static const String id = 'id';
  static const String amount = 'amount';
  static const String category = 'category';
  static const String description = 'description';
  static const String date = 'date';
  static const String positive = 'positive';

  static const List<String> columns = [id, amount, category, description, date];
  static final List<String> categories = categoryIcons.keys.toList();

  static const String createTable = '''
    CREATE $schema
  ''';

  static const String schema = '''
    TABLE $table (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $amount REAL,
      $category TEXT,
      $description TEXT,
      $date TEXT,
      $positive INTEGER
    )
  ''';
}

class AccountTable {
  static const String table = 'accounts';
  static const String id = 'id';
  static const String name = 'name';
  static const String balance = 'balance';
  static const String cardNumber = 'cardNumber';
  static const String expiryDate = 'expiryDate';
  static const String bankName = 'bankName';
  static const String holderName = 'holderName';

  static const List<String> columns = [
    id,
    name,
    balance,
    cardNumber,
    expiryDate,
    bankName,
    holderName,
  ];

  static const String createTable = '''
    CREATE $schema
  ''';

  static const String schema = '''
    TABLE $table (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $name TEXT,
      $balance REAL,
      $cardNumber TEXT,
      $expiryDate TEXT,
      $bankName TEXT,
      $holderName TEXT
    )
  ''';
}
