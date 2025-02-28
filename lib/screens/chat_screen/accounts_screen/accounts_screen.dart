import 'package:budgeting_app/models/account_model.dart';
import 'package:budgeting_app/screens/chat_screen/components/account_operations_renderer.dart';
import 'package:budgeting_app/screens/expenses_screen/expenses_screen.dart';
import 'package:budgeting_app/states/accounts/accounts_crud_requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        actions: [GeminiChatButton()],
      ),
      body: const _AccountsListDataProvider(),
    );
  }
}

class _AccountsListDataProvider extends StatelessWidget {
  const _AccountsListDataProvider();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountsCrudRequestsCubit, AccountRequestState>(
      builder: (context, state) {
        if (state.status == AccountRequestStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == AccountRequestStatus.error) {
          return const Center(child: Text('An error occurred'));
        }

        final accounts = state.accounts;

        if (accounts.isEmpty) {
          return const Center(child: Text('No accounts found'));
        }

        return _AccountsList(accounts: accounts);
      },
    );
  }
}

class _AccountsList extends StatelessWidget {
  final List<Account> accounts;
  const _AccountsList({required this.accounts});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: accounts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final account = accounts[index];

        return InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AccountCreditCard(account: account),
          ),
          onTap: () {
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => ExpensesScreen(),
            //   ),
            // );
          },
        );
      },
    );
  }
}
