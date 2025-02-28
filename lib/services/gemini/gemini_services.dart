import 'dart:io';

import 'package:budgeting_app/db/database_manager.dart';
import 'package:budgeting_app/models/base_embedding_model.dart';
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
          FunctionDeclaration(
            _accessDatabaseFunction.identifier,
            _accessDatabaseFunction.description,
            parameters: _accessDatabaseFunction.parametersSchema,
          ),
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

        You are also powered up with the option of replying with embeddings in the response.

        Your available embeddings are: Charts, and Expense Operations.

        To embed a chart, you can use a json code block like this:
        ```json
        {
          "type": "${EmbeddingParser.chart}",
          "data": {
            "chartType": "line or bar or pie",
            "labels": ["label1", "label2", "label3", ...],
            "series": [
              {
                "name": "series1",
                "data": [1, 2, 3, ...]
              },
              {
                "name": "series2",
                "data": [4, 5, 6, ...]
              },
              ...
            ]
          }
        }
        ```
        The chart will be rendered to a UI component from this json so it must always be valid and parsable.
        Note: For pie charts, there will only be one series.

        To embed an expense operation, you can use a json code block like this:
        ```json
        {
          "type": "${EmbeddingParser.expenseOperation}",
          "data": [
            {
              "operationType": "read or add or update or delete",
              "${ExpensesTable.id}": An integer ID, not included if operation is add,
              "${ExpensesTable.amount}": a valid double
              "${ExpensesTable.category}": A string, one of ${ExpensesTable.categories},
              "${ExpensesTable.description}": The description of the expense,
              "${ExpensesTable.date}": The date of the expense in ISO 8601 format
              "${ExpensesTable.positive}": An Integer, 1 for true, 0 for false
            },
            ...
          ]
        }
        ```
        Note that these expense operations show up as suggestions to the user, and the user can choose to apply the changes
        or not. Never do these operations using SQL, the operation will be parsed through the JSON and handled in the app.
        **IMPORTANT: All fields are required.**

        General notes:
        Today is: ${DateTime.now().toIso8601String()}
        The app is used currently in Egypt.
        The currency is EGP.

        # Natural Language Formatting Guidelines
        Markdown: Use Markdown for all natural language responses.
        Headings: # Heading 1, ## Heading 2, etc.
        Lists:
        Use dashes (-) for unordered lists.
        Use numbers (1., 2., 3.) for ordered lists.
        Horizontal Lines: Use ---. Wrap the line in an empty line before and after.
        Tables: Use Markdown tables (never use :--- for alignment it is not supported), (use ----- to separate header).
        Text Formatting: Bold, italic, and strikethrough.
        Math: Use inline LaTeX, e.g., \(\frac{a}{b}\).

        Here are possible query types that may be asked of you and how to best handle them.

        # Query Handling Procedures
        1. General Expense/Budgeting Queries (No Database Required):
        Respond directly with clear, natural language answers.

        2. Queries Requiring Database Data:
        Use ${_accessDatabaseFunction.identifier} to query the database.
        Provide a natural language summary of the data, optionally including embedded charts or data highlights.

        3. Queries Requiring Data Visualization:
        Retrieve the necessary data using the database function.
        Respond with a clear explanation and include a <chart> embedding.
        For single-series data, prefer pie charts.
        For multi-series data, if there are many labels, prefer line charts; otherwise, bar charts.
        Limit or group labels as needed for clarity.

        4. Expense CRUD Operations:
        For read/update/delete operations, first query the database to confirm data. Then, respond with suggestions using expenseOperations embedding for user confirmation.
        For add operations, you can propose the addition directly if no prior data check is needed.
        Use a suggestive tone (e.g., "I have made a suggestion to add...") to ensure the user can confirm changes.
        *Prefer read operations if you would like to show the user specific expenses instead of showing them in lists or tables*
        ****Never use database access to write data, the writing is always done by the app after user confirmation.****
        ****When adding a new expense that will be dated to the most recent date, you should use a SQL database function
        to get the current date and time.****

        Crucial: Some queries may require combining multiple procedures. In such cases, simply go through the steps sequentially.

        Response guidelines:
        - Provide the response in a helpful tone.
        - Avoid responding with nothing but embeddings.
        - Your language should be one with the app, it should feel like your responses naturally fit in the app.
        - Never ever include code or SQL queries in your responses.
        - All SQL queries should be handled by the ${_accessDatabaseFunction.identifier} function.
      '''),
    );
  }

  Future<String> prompt({required String query, List<File>? images}) async {
    final Content content = await _getContent(query: query, images: images);
    final chat = _model.startChat();

    final initialResponse = await chat.sendMessage(content);

    return _handleResponse(chat: chat, response: initialResponse);
  }

  Future<Content> _getContent({
    required String query,
    List<File>? images,
  }) async {
    if (images == null) {
      return Content.text(query);
    }

    final textPart = TextPart(query);
    final imageParts = [
      for (final image in images)
        InlineDataPart('image/jpeg', await image.readAsBytes()),
    ];

    return Content.multi([textPart, ...imageParts]);
  }

  Future<String> _handleResponse({
    required ChatSession chat,
    required GenerateContentResponse response,
  }) async {
    if (response.functionCalls.isEmpty) {
      return response.text ?? 'Sorry, I could not process your query';
    }

    final resolvedResponse = await _resolveFunctionCalls(
      response.functionCalls,
    );

    final newResponse = await chat.sendMessage(resolvedResponse);

    return _handleResponse(chat: chat, response: newResponse);
  }

  Future<Content> _resolveFunctionCalls(
    Iterable<FunctionCall> functionCalls,
  ) async {
    final List<Map<String, dynamic>> functionCallResults = [];

    for (final functionCall in functionCalls) {
      final functionIdentifier = functionCall.name;
      final parameters = functionCall.args;

      final result = await _accessDatabaseFunction.execute(parameters);

      functionCallResults.add({functionIdentifier: result});
    }

    if (functionCallResults.length == 1) {
      return Content.functionResponse(
        _accessDatabaseFunction.identifier,
        functionCallResults.single,
      );
    }

    return Content.functionResponses([
      for (final result in functionCallResults)
        FunctionResponse(_accessDatabaseFunction.identifier, result),
    ]);
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
