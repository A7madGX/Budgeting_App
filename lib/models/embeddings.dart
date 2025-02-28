import 'package:budgeting_app/models/account_model.dart';
import 'package:budgeting_app/models/expense_model.dart';

sealed class BaseEmbeddingModel {}

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

  factory ExpenseOperations.fromJson(List json) {
    return ExpenseOperations(
      json.map((e) => ExpenseOperation.fromMap(e)).toList(),
    );
  }
}

class Chart extends BaseEmbeddingModel {
  final ChartType type;
  final List<String> labels;
  final List<Series> series;

  Chart({required this.type, required this.labels, required this.series});

  factory Chart.fromJson(Map<String, dynamic> json) {
    final type = ChartType.fromString(json['chartType'] as String);
    final labels = (json['labels'] as List).cast<String>();
    final series =
        (json['series'] as List).map((e) => Series.fromJson(e)).toList();

    return Chart(type: type, labels: labels, series: series);
  }

  List<String> get legend => series.map((e) => e.name).toList();
}

class Series {
  final String name;
  final List<num> data;

  Series({required this.name, required this.data});

  factory Series.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String;
    final data = (json['data'] as List).cast<num>();

    return Series(name: name, data: data);
  }
}

enum ChartType {
  line,
  bar,
  pie;

  static ChartType fromString(String value) {
    switch (value) {
      case 'line':
        return ChartType.line;
      case 'bar':
        return ChartType.bar;
      case 'pie':
        return ChartType.pie;
      default:
        throw ArgumentError('Invalid ChartType: $value');
    }
  }
}

class AccountOperation {
  final Account account;
  final OperationType type;

  AccountOperation({required this.account, required this.type});

  factory AccountOperation.fromMap(Map<String, dynamic> json) {
    return AccountOperation(
      account: Account.fromMap(json),
      type: OperationType.fromString(json['operationType'] as String),
    );
  }
}

class AccountOperations extends BaseEmbeddingModel {
  final List<AccountOperation> operations;

  AccountOperations(this.operations);

  factory AccountOperations.fromJson(List json) {
    return AccountOperations(
      json.map((e) => AccountOperation.fromMap(e)).toList(),
    );
  }
}
