import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:budgeting_app/extensions.dart';
import 'package:budgeting_app/models/embeddings.dart';
import 'package:budgeting_app/widgets/expense_list_item.dart';
import 'package:budgeting_app/widgets/gemini_embed_card.dart';
import 'package:budgeting_app/widgets/gemini_logo.dart';
import 'package:budgeting_app/widgets/shimmer_animated.dart';
import 'package:flutter/material.dart';

class ExpenseOperationsRenderer extends StatefulWidget {
  const ExpenseOperationsRenderer({super.key, required this.expenseOperations});

  final List<ExpenseOperation> expenseOperations;

  @override
  State<ExpenseOperationsRenderer> createState() =>
      _ExpenseOperationsRendererState();
}

class _ExpenseOperationsRendererState extends State<ExpenseOperationsRenderer> {
  bool _hasExecutedOperations = false;

  @override
  Widget build(BuildContext context) {
    final allOperationsAreRead = widget.expenseOperations.every(
      (operation) => operation.type == OperationType.read,
    );

    return Column(
      spacing: 8,
      children: [
        GeminiEmbedCard(
          enableGlowAnimation: !allOperationsAreRead && !_hasExecutedOperations,
          padding: EdgeInsets.zero,
          child: SizedBox(
            width: double.infinity,
            child:
                widget.expenseOperations.length > 3
                    ? _buildScrollableList(widget.expenseOperations)
                    : _buildUnscrollableList(context, widget.expenseOperations),
          ),
        ),
        if (!allOperationsAreRead)
          GeminiEmbedCard(
            enableGlowAnimation: !_hasExecutedOperations,
            padding: EdgeInsets.zero,
            borderRadius: 1000,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {
                setState(() {
                  _hasExecutedOperations = true;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  GeminiLogo(
                    enableAnimations: true,
                    color: context.colorScheme.primary,
                    size: 18,
                  ),
                  ShimmerAnimated(child: const Text('Apply Changes')),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildScrollableList(List<ExpenseOperation> operations) {
    return SizedBox(
      height: 300,
      child: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: operations.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final operation = operations[index];

          return _buildItem(context, operation);
        },
      ),
    );
  }

  Widget _buildUnscrollableList(
    BuildContext context,
    List<ExpenseOperation> operations,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 8.0,
        children:
            operations.map((operation) {
              return _buildItem(context, operation);
            }).toList(),
      ),
    );
  }

  Widget _buildItem(BuildContext context, ExpenseOperation operation) {
    final operationColor = switch (operation.type) {
      OperationType.add => context.colorScheme.primary,
      OperationType.update => context.colorScheme.tertiary,
      OperationType.delete => context.colorScheme.error,
      OperationType.read => Colors.transparent,
    };

    final message1String =
        _hasExecutedOperations ? 'Gemini has ' : 'Gemini wants to ';
    final operationPastSuffix =
        _hasExecutedOperations
            ? operation.type.name.endsWith('e')
                ? 'd'
                : 'ed'
            : '';
    final message2String = ' an expense';

    return ListItemContainer(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (operation.type != OperationType.read)
              ShimmerAnimated(
                color: operationColor,
                child: AnimatedSwitcherFlip.flipX(
                  duration: const Duration(milliseconds: 500),
                  child: Row(
                    key: ValueKey(_hasExecutedOperations),
                    spacing: 4,
                    children: [
                      GeminiLogo(
                        enableAnimations: false,
                        color: operationColor,
                        size: 14,
                      ),
                      RichText(
                        text: TextSpan(
                          style: context.textTheme.labelMedium?.copyWith(
                            color:
                                _hasExecutedOperations
                                    ? operationColor
                                    : context.colorScheme.onSurface,
                          ),
                          children: [
                            TextSpan(text: message1String),
                            TextSpan(
                              text: operation.type.name + operationPastSuffix,
                              style: TextStyle(color: operationColor),
                            ),
                            TextSpan(text: message2String),
                          ],
                        ),
                      ),
                      if (_hasExecutedOperations)
                        Icon(
                          operation.type == OperationType.delete
                              ? Icons.delete
                              : Icons.check_rounded,
                          color: operationColor,
                          size: 13,
                        ),
                    ],
                  ),
                ),
              ),
            ExpenseListItemContent(expense: operation.expense),
          ],
        ),
      ),
    );
  }
}
