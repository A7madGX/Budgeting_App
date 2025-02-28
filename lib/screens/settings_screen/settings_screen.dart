import 'package:budgeting_app/extensions.dart';
import 'package:budgeting_app/main.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 8,
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
          ],
        ),
      ),
    );
  }
}
