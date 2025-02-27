import 'dart:io';

import 'package:budgeting_app/db/database_manager.dart';
import 'package:budgeting_app/services/gemini/functions.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';

class GeminiServices {
  late GenerativeModel _model;

  final _accessDatabaseFunction = AccessDatabaseFunction();

  GeminiServices() {
    setModel(GeminiModels.geminiPro2);
  }

  void setModel(GeminiModels model) {
    _model = FirebaseVertexAI.instance.generativeModel(
      model: model.modelName,
      tools: [
        Tool.functionDeclarations([
          FunctionDeclaration(_accessDatabaseFunction.identifier, _accessDatabaseFunction.description, parameters: _accessDatabaseFunction.parametersSchema),
        ]),
      ],
      systemInstruction: Content.system('''
        You are a smart assistant for a simple expense tracking mobile application.
        The app runs on an internal SQLite database which has a single table called expenses.
        Here is the schema:

        ${ExpensesTable.schema}

        You have access to the database and can execute SQL queries on it through the
        ${_accessDatabaseFunction.identifier} function.

        You can use the function by providing a query parameter with a valid SQLite query.
      '''),
    );
  }

  Future<String> prompt({required String query, List<File>? images}) async {
    final Content content = await _getContent(query: query, images: images);
    final chat = _model.startChat();

    final initialResponse = await chat.sendMessage(content);

    return _handleResponse(chat: chat, response: initialResponse);
  }

  Future<Content> _getContent({required String query, List<File>? images}) async {
    if (images == null) {
      return Content.text(query);
    }

    final textPart = TextPart(query);
    final imageParts = [for (final image in images) InlineDataPart('image/jpeg', await image.readAsBytes())];

    return Content.multi([textPart, ...imageParts]);
  }

  Future<String> _handleResponse({required ChatSession chat, required GenerateContentResponse response}) async {
    if (response.functionCalls.isEmpty) {
      return response.text ?? 'Sorry, I could not process your query';
    }

    final resolvedResponse = await _resolveFunctionCalls(response.functionCalls);

    final newResponse = await chat.sendMessage(resolvedResponse);

    return _handleResponse(chat: chat, response: newResponse);
  }

  Future<Content> _resolveFunctionCalls(Iterable<FunctionCall> functionCalls) async {
    final List<Map<String, dynamic>> functionCallResults = [];

    for (final functionCall in functionCalls) {
      final functionIdentifier = functionCall.name;
      final parameters = functionCall.args;

      final result = await _accessDatabaseFunction.execute(parameters);

      functionCallResults.add({functionIdentifier: result});
    }

    if (functionCallResults.length == 1) {
      return Content.functionResponse(_accessDatabaseFunction.identifier, functionCallResults.single);
    }

    return Content.functionResponses([for (final result in functionCallResults) FunctionResponse(_accessDatabaseFunction.identifier, result)]);
  }
}

enum GeminiModels {
  geminiPro2,
  geminiFlash2;

  String get modelName {
    return switch (this) {
      GeminiModels.geminiPro2 => 'gemini-2.0-pro-exp-02-05',
      GeminiModels.geminiFlash2 => 'gemini-2.0-flash-001',
    };
  }
}
