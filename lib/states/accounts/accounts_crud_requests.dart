import 'package:budgeting_app/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/account_model.dart';

part 'accounts_crud_requests.freezed.dart';

class AccountsCrudRequestsCubit extends Cubit<AccountRequestState> {
  AccountsCrudRequestsCubit() : super(AccountRequestState.initial()) {
    fetchAccounts();
  }

  Future<void> updateAccount(Account account) async {
    emit(state.copyWith(status: AccountRequestStatus.loading));
    try {
      await dbManager.updateAccount(account);
      emit(state.copyWith(status: AccountRequestStatus.success));
    } catch (e) {
      emit(state.copyWith(status: AccountRequestStatus.error));
    }
    await fetchAccounts();
  }

  Future<void> insertAccount(Account account) async {
    emit(state.copyWith(status: AccountRequestStatus.loading));
    try {
      await dbManager.insertAccount(account);
      emit(state.copyWith(status: AccountRequestStatus.success));
    } catch (e) {
      emit(state.copyWith(status: AccountRequestStatus.error));
    }
    await fetchAccounts();
  }

  Future<void> deleteAccount(int id) async {
    emit(state.copyWith(status: AccountRequestStatus.loading));
    try {
      await dbManager.deleteAccount(id);
      emit(state.copyWith(status: AccountRequestStatus.success));
    } catch (e) {
      emit(state.copyWith(status: AccountRequestStatus.error));
    }
    await fetchAccounts();
  }

  Future<void> fetchAccounts() async {
    emit(state.copyWith(status: AccountRequestStatus.loading));

    try {
      final accounts = await dbManager.getAccounts();
      emit(
        state.copyWith(
          status: AccountRequestStatus.success,
          accounts: accounts,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: AccountRequestStatus.error));
    }
  }
}

@freezed
abstract class AccountRequestState with _$AccountRequestState {
  const factory AccountRequestState({
    required AccountRequestStatus status,
    required List<Account> accounts,
  }) = _AccountRequestState;

  factory AccountRequestState.initial() =>
      AccountRequestState(status: AccountRequestStatus.initial, accounts: []);
}

enum AccountRequestStatus { initial, loading, success, error }
