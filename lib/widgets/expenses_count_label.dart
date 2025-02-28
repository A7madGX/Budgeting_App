import 'package:budgeting_app/extensions.dart';
import 'package:flutter/material.dart';

class ExpensesCountLabel extends StatelessWidget {
  const ExpensesCountLabel({
    super.key,
    required this.count,
    this.invertColors = false,
  });

  final int count;
  final bool invertColors;

  @override
  Widget build(BuildContext context) {
    final background =
        invertColors
            ? context.colorScheme.primary
            : context.colorScheme.primaryContainer;

    final foreground =
        invertColors
            ? context.colorScheme.onPrimary
            : context.colorScheme.onPrimaryContainer;
    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: EdgeInsets.only(right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Icon(Icons.receipt_long, color: foreground),
          Text(
            count.toString(),
            style: context.textTheme.labelLarge?.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}
