import 'package:budgeting_app/models/account_model.dart';
import 'package:budgeting_app/models/expense_model.dart';
import 'package:budgeting_app/screens/expenses_screen/expenses_screen.dart';
import 'package:budgeting_app/states/expenses/expenses_crud_requests.dart';
import 'package:budgeting_app/widgets/expense_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountExpensesScreen extends StatelessWidget {
  const AccountExpensesScreen({super.key, required this.account});

  final Account account;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExpensesCrudRequestsCubit>(
      create: (context) => ExpensesCrudRequestsCubit(accountId: account.id),
      child: Scaffold(
        appBar: AppBar(
          title: Text(account.name),
          actions: [GeminiChatButton()],
        ),
        body: const _AccountExpensesListDataProvider(),
      ),
    );
  }
}

class _AccountExpensesListDataProvider extends StatelessWidget {
  const _AccountExpensesListDataProvider();

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

        return _AccountExpensesList(expenses: expenses);
      },
    );
  }
}

class _AccountExpensesList extends StatelessWidget {
  final List<Expense> expenses;
  const _AccountExpensesList({required this.expenses});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: expenses.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return ListItemContainer(
          child: ExpenseListItemContent(expense: expense),
        );
      },
    );
  }
}
