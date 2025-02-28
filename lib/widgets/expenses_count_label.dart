import 'package:budgeting_app/extensions.dart';
import 'package:flutter/material.dart';

class ExpensesCountLabel extends StatelessWidget {
  const ExpensesCountLabel({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: EdgeInsets.only(right: 8),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            Icon(
              Icons.receipt_long,
              color: context.colorScheme.onPrimaryContainer,
            ),
            Text(
              count.toString(),
              style: context.textTheme.labelLarge?.copyWith(
                color: context.colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
