import 'package:budgeting_app/models/expense_model.dart';
import 'package:budgeting_app/screens/chat_screen/chat_screen.dart';
import 'package:budgeting_app/screens/chat_screen/state/chat_view_model.dart';
import 'package:budgeting_app/states/expenses_crud_requests.dart';
import 'package:budgeting_app/widgets/expense_list_item.dart';
import 'package:budgeting_app/widgets/gemini_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: [
          IconButton(
            icon: GeminiLogo(),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => BlocProvider.value(
                        value: context.read<ChatViewModel>(),
                        child: const ChatScreen(),
                      ),
                ),
              );
            },
          ),
        ],
      ),
      body: const _ExpensesListDataProvider(),
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
