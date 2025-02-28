import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:budgeting_app/constants.dart';
import 'package:budgeting_app/extensions.dart';
import 'package:budgeting_app/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

class ListItemContainer extends StatelessWidget {
  const ListItemContainer({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    );

    return Container(
      decoration: ShapeDecoration(shape: shape),
      child: Material(
        color: context.colorScheme.surfaceContainer,
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

class ExpenseListItem extends StatelessWidget {
  const ExpenseListItem({
    super.key,
    required this.expense,
    required this.isSelected,
    required this.onSelectionChanged,
  });

  final Expense expense;
  final bool isSelected;
  final ValueChanged<bool> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return ListItemContainer(
      onTap: () {
        // TODO: Navigate to expense details screen
      },
      child: Row(
        children: [
          Expanded(child: ExpenseListItemContent(expense: expense)),
          IconButton(
            icon: AnimatedSwitcherPlus.zoomIn(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                key: ValueKey(isSelected),
                isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                color:
                    isSelected
                        ? context.colorScheme.primary
                        : context.colorScheme.onSurface,
              ),
            ),
            onPressed: () {
              onSelectionChanged(!isSelected);
            },
          ),
        ],
      ),
    );
  }
}

class ExpenseListItemContent extends StatefulWidget {
  const ExpenseListItemContent({super.key, required this.expense});

  final Expense expense;

  @override
  State<ExpenseListItemContent> createState() => _ExpenseListItemContentState();
}

class _ExpenseListItemContentState extends State<ExpenseListItemContent> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.parse(widget.expense.date);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Row(
              spacing: 16.0,
              children: [
                CircleAvatar(
                  backgroundColor: context.colorScheme.surfaceContainerHighest,
                  child: Icon(
                    widget.expense.positive
                        ? incomeCategoryIcons[widget.expense.category]
                        : expenseCategoryIcons[widget.expense.category],
                    color:
                        widget.expense.positive
                            ? context.colorScheme.primary
                            : context.colorScheme.error,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.expense.category,
                      style: context.textTheme.titleMedium,
                    ),
                    Text(
                      DateFormat.yMMMMd().format(dateTime),
                      style: context.textTheme.labelMedium,
                    ),
                    Text(
                      '${widget.expense.positive ? '+' : '-'}${NumberFormat.currency(locale: 'en_US', symbol: 'EGP ').format(widget.expense.amount)}',
                      style: context.textTheme.labelLarge?.copyWith(
                        color: context.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            AnimatedSize(
              duration: 500.ms,
              curve: Curves.easeInOut,
              child: AnimatedSwitcher(
                duration: 500.ms,
                child:
                    _isExpanded
                        ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.expense.description.isNotEmpty)
                              Row(
                                spacing: 8,
                                children: [
                                  Icon(Icons.notes_rounded, size: 16),
                                  Expanded(
                                    child: Text(
                                      widget.expense.description,
                                      style: context.textTheme.bodyMedium,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            if (widget.expense.account != null)
                              Row(
                                spacing: 8,
                                children: [
                                  Icon(Icons.credit_card_rounded, size: 16),
                                  Text(
                                    widget.expense.account!.name,
                                    style: context.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                          ],
                        )
                        : SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
