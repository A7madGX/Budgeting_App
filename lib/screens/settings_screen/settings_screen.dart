import 'package:budgeting_app/extensions.dart';
import 'package:budgeting_app/main.dart';
import 'package:budgeting_app/services/db/database_stub_data_service.dart';
import 'package:budgeting_app/states/expenses/expenses_crud_requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 48,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              spacing: 8,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    Icon(Icons.color_lens, size: 24),
                    Text('Theme', style: context.textTheme.titleMedium),
                  ],
                ),
                Divider(height: 0),
                Row(
                  children: [
                    Text('Dark mode', style: context.textTheme.titleSmall),
                    const Spacer(),
                    Switch(
                      value:
                          ThemeController.of(context).theme == Brightness.dark,
                      onChanged: (value) {
                        ThemeController.of(
                          context,
                        ).setTheme(value ? Brightness.dark : Brightness.light);
                      },
                    ),
                  ],
                ),
                Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Primary color', style: context.textTheme.titleSmall),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final color in Colors.primaries)
                          Material(
                            shape: CircleBorder(),
                            color: color,
                            child: InkWell(
                              customBorder: CircleBorder(),
                              onTap: () {
                                ThemeController.of(
                                  context,
                                ).setPrimaryColor(color);
                              },
                              child: SizedBox.square(dimension: 32),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Column(
              spacing: 8,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    Icon(Icons.language, size: 24),
                    Text('Language', style: context.textTheme.titleMedium),
                  ],
                ),
                Divider(height: 0),
                Row(
                  children: [
                    Text('English', style: context.textTheme.titleSmall),
                    const Spacer(),
                    Checkbox(value: true, onChanged: (value) {}),
                  ],
                ),
                Row(
                  children: [
                    Text('Arabic', style: context.textTheme.titleSmall),
                    const Spacer(),
                    Checkbox(value: false, onChanged: (value) {}),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    Icon(Icons.info, size: 24),
                    Text('Dev', style: context.textTheme.titleMedium),
                  ],
                ),
                Divider(height: 0),
                LoadDataButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LoadDataButton extends StatefulWidget {
  const LoadDataButton({super.key});

  @override
  State<LoadDataButton> createState() => _LoadDataButtonState();
}

class _LoadDataButtonState extends State<LoadDataButton> {
  Future<void>? _loadDataFuture;

  Future<void> _loadData(BuildContext context) async {
    final stubService = DatabaseStubDataService(dbManager);
    await stubService.generateStubData();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stub data successfully generated')),
      );

      context.read<ExpensesCrudRequestsCubit>().fetchExpenses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadDataFuture,
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState == ConnectionState.waiting;

        return ElevatedButton(
          onPressed:
              isLoading
                  ? null
                  : () {
                    setState(() {
                      _loadDataFuture = _loadData(context);
                    });
                  },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [
              isLoading
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      year2023: false,
                    ),
                  )
                  : const Icon(Icons.download_rounded),
              Text(isLoading ? 'Loading...' : 'Load Data'),
            ],
          ),
        );
      },
    );
  }
}
