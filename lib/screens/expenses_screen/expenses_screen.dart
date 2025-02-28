import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:budgeting_app/extensions.dart';
import 'package:budgeting_app/models/expense_model.dart';
import 'package:budgeting_app/screens/home_screen/home_screen.dart';
import 'package:budgeting_app/states/chat/chat_view_model.dart';
import 'package:budgeting_app/states/expenses/expenses_crud_requests.dart';
import 'package:budgeting_app/widgets/expense_list_item.dart';
import 'package:budgeting_app/widgets/gemini_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: [GeminiChatButton()],
      ),
      body: const _ExpensesListDataProvider(),
      floatingActionButton: ExpensesCounter(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class GeminiChatButton extends StatelessWidget {
  const GeminiChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: BlocSelector<ChatViewModel, ChatState, List<Expense>>(
        selector: (state) => state.selectedExpenses,
        builder: (context, selectedExpenses) {
          return GeminiLogo(enableAnimations: selectedExpenses.isNotEmpty);
        },
      ),
      onPressed: () {
        NavigationController.of(context).goToChatScreen();
      },
    );
  }
}

class _ExpensesListDataProvider extends StatelessWidget {
  const _ExpensesListDataProvider();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpensesCrudRequestsCubit, ExpenseRequestState>(
      builder: (context, state) {
        if (state.status == ExpenseRequestStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == ExpenseRequestStatus.error) {
          return const Center(child: Text('An error occurred'));
        }

        final expenses = state.expenses;

        if (expenses.isEmpty) {
          return const Center(child: Text('No expenses found'));
        }

        return _ExpensesList(expenses: expenses);
      },
    );
  }
}

class _ExpensesList extends StatelessWidget {
  final List<Expense> expenses;
  const _ExpensesList({required this.expenses});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: expenses.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final expense = expenses[index];

        return BlocBuilder<ChatViewModel, ChatState>(
          builder: (context, state) {
            final bool isSelected = state.isExpenseSelected(expense);

            return ExpenseListItem(
              expense: expense,
              isSelected: isSelected,
              onSelectionChanged: (bool isSelected) {
                context.read<ChatViewModel>().toggleExpenseSelection(expense);
              },
            );
          },
        );
      },
    );
  }
}

class ExpensesCounter extends StatelessWidget {
  const ExpensesCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatViewModel, ChatState>(
      builder: (context, state) {
        final selectedExpenses = state.selectedExpenses;

        return AnimatedSwitcherPlus.zoomOut(
          duration: 250.ms,
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child:
              selectedExpenses.isEmpty
                  ? const SizedBox()
                  : _buildCounter(context, selectedExpenses.length),
        );
      },
    );
  }

  Widget _buildCounter(BuildContext context, int count) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: Text(
        '$count Expense(s) selected',
        style: context.textTheme.labelLarge?.copyWith(
          color: context.colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
