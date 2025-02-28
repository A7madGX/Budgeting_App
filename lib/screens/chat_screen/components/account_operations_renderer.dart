import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:budgeting_app/extensions.dart';
import 'package:budgeting_app/models/account_model.dart';
import 'package:budgeting_app/models/embeddings.dart';
import 'package:budgeting_app/states/accounts/accounts_crud_requests.dart';
import 'package:budgeting_app/widgets/gemini_embed_card.dart';
import 'package:budgeting_app/widgets/gemini_logo.dart';
import 'package:budgeting_app/widgets/shimmer_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_credit_card/u_credit_card.dart';

class AccountOperationsRenderer extends StatefulWidget {
  const AccountOperationsRenderer({super.key, required this.operations});

  final List<AccountOperation> operations;

  @override
  State<AccountOperationsRenderer> createState() =>
      _AccountOperationsRendererState();
}

class _AccountOperationsRendererState extends State<AccountOperationsRenderer> {
  bool _hasExecutedOperations = false;

  @override
  Widget build(BuildContext context) {
    final allOperationsAreRead = widget.operations.every(
      (operation) => operation.type == OperationType.read,
    );

    return Column(
      spacing: 8.0,
      children: [
        GeminiEmbedCard(
          enableGlowAnimation: !allOperationsAreRead && !_hasExecutedOperations,
          padding: EdgeInsets.zero,
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.operations.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final operation = widget.operations[index];
                  return _buildAccountItem(context, operation);
                },
              ),
            ),
          ),
        ),
        if (!allOperationsAreRead)
          AnimatedSize(
            duration: 500.ms,
            curve: Curves.easeInOut,
            child: AnimatedSwitcher(
              duration: 500.ms,
              child:
                  _hasExecutedOperations
                      ? const SizedBox()
                      : ApplyChangesButton(
                        onPressed: () async {
                          final futures = widget.operations.map((operation) {
                            switch (operation.type) {
                              case OperationType.add:
                                return executeAccountAdd(
                                  context: context,
                                  account: operation.account,
                                );
                              case OperationType.update:
                                return executeAccountUpdate(
                                  context: context,
                                  account: operation.account,
                                );
                              case OperationType.delete:
                                return executeAccountDelete(
                                  context: context,
                                  account: operation.account,
                                );
                              case OperationType.read:
                                return Future.value();
                            }
                          });

                          await Future.wait(futures);

                          setState(() {
                            _hasExecutedOperations = true;
                          });
                        },
                      ),
            ),
          ),
      ],
    );
  }

  Widget _buildAccountItem(BuildContext context, AccountOperation operation) {
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
    final message2String = ' an account';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 8.0,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (operation.type != OperationType.read)
            ShimmerAnimated(
              color: operationColor,
              child: AnimatedSwitcherFlip.flipX(
                duration: const Duration(milliseconds: 500),
                child: Row(
                  key: ValueKey(_hasExecutedOperations),
                  children: [
                    GeminiLogo(
                      enableAnimations: false,
                      color: operationColor,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(
                          operation.type == OperationType.delete
                              ? Icons.delete
                              : Icons.check_rounded,
                          color: operationColor,
                          size: 13,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          AccountCreditCard(account: operation.account),
        ],
      ),
    );
  }
}

class ApplyChangesButton extends StatelessWidget {
  const ApplyChangesButton({super.key, required this.onPressed});
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GeminiEmbedCard(
      padding: EdgeInsets.zero,
      borderRadius: 1000,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: onPressed,
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
    );
  }
}

class AccountCreditCard extends StatelessWidget {
  const AccountCreditCard({super.key, required this.account});

  final Account account;

  @override
  Widget build(BuildContext context) {
    final expiryDate = DateTime.parse(account.expiryDate);
    return Center(
      child: Column(
        spacing: 4,
        children: [
          Text(account.name, style: context.textTheme.titleMedium),
          CreditCardUi(
            width: 400,
            cardHolderFullName: account.holderName,
            cardNumber: '**** **** **** ${account.cardNumber}',
            validThru:
                '${expiryDate.month.toString().padLeft(2, '0')}/${expiryDate.year.toString().substring(2)}',
            validFrom:
                '${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year.toString().substring(2)}',
            topLeftColor: context.colorScheme.primaryContainer,
            bottomRightColor: context.colorScheme.tertiaryContainer,
            doesSupportNfc: true,
            balance: account.balance.toDouble(),
            showBalance: true,
            currencySymbol: 'EGP ',
            autoHideBalance: true,
            enableFlipping: true,
          ),
        ],
      ),
    );
  }
}

Future<void> executeAccountAdd({
  required BuildContext context,
  required Account account,
}) async {
  return context.read<AccountsCrudRequestsCubit>().insertAccount(account);
}

Future<void> executeAccountUpdate({
  required BuildContext context,
  required Account account,
}) async {
  return context.read<AccountsCrudRequestsCubit>().updateAccount(account);
}

Future<void> executeAccountDelete({
  required BuildContext context,
  required Account account,
}) async {
  return context.read<AccountsCrudRequestsCubit>().deleteAccount(account.id!);
}
