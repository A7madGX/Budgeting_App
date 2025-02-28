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

class _AccountExpensesList extends StatefulWidget {
  final List<Expense> expenses;
  const _AccountExpensesList({required this.expenses});

  @override
  State<_AccountExpensesList> createState() => _AccountExpensesListState();
}

class _AccountExpensesListState extends State<_AccountExpensesList> {
  ExpenseFilter _currentFilter = ExpenseFilter.all;

  @override
  Widget build(BuildContext context) {
    final filteredExpenses = _getFilteredExpenses();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<ExpenseFilter>(
                segments: const [
                  ButtonSegment(value: ExpenseFilter.all, label: Text('All')),
                  ButtonSegment(
                    value: ExpenseFilter.expense,
                    label: Text('Expenses'),
                  ),
                  ButtonSegment(
                    value: ExpenseFilter.income,
                    label: Text('Income'),
                  ),
                ],
                selected: {_currentFilter},
                onSelectionChanged: (Set<ExpenseFilter> newSelection) {
                  setState(() {
                    _currentFilter = newSelection.first;
                  });
                },
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList.separated(
            itemCount: filteredExpenses.length,
            itemBuilder: (context, index) {
              final expense = filteredExpenses[index];
              return ListItemContainer(
                child: ExpenseListItemContent(expense: expense),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 8),
          ),
        ),
      ],
    );
  }

  List<Expense> _getFilteredExpenses() {
    switch (_currentFilter) {
      case ExpenseFilter.all:
        return widget.expenses;
      case ExpenseFilter.expense:
        return widget.expenses.where((expense) => !expense.positive).toList();
      case ExpenseFilter.income:
        return widget.expenses.where((expense) => expense.positive).toList();
    }
  }
}
