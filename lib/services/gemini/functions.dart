import 'package:budgeting_app/main.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';

class AccessDatabaseFunction {
  static const String query = 'query';

  String get identifier => 'accessDatabase';

  String get description => '''
    Executes a SQLite query on the database and returns the results.
  ''';

  Map<String, Schema> get parametersSchema {
    return {query: Schema.string(description: 'A SQLite query to execute on the database and receive the results.')};
  }

  Future<Map<String, dynamic>> execute(Map<String, dynamic> parameters) async {
    final query = parameters[AccessDatabaseFunction.query] as String;

    final results = await dbManager.rawQuery(query);

    return {'results': results};
  }
}
