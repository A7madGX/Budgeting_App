import 'package:budgeting_app/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/expense_model.dart';

part 'expenses_crud_requests.freezed.dart';

class ExpensesCrudRequestsCubit extends Cubit<ExpenseRequestState> {
  ExpensesCrudRequestsCubit() : super(ExpenseRequestState.initial()) {
    fetchExpenses();
  }

  Future<void> updateExpense(Expense expense) async {
    emit(state.copyWith(status: ExpenseRequestStatus.loading));
    try {
      await dbManager.updateExpense(expense);
      emit(state.copyWith(status: ExpenseRequestStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ExpenseRequestStatus.error));
    }
    await fetchExpenses();
  }

  Future<void> insertExpense(Expense expense) async {
    emit(state.copyWith(status: ExpenseRequestStatus.loading));
    try {
      await dbManager.insertExpense(expense);
      emit(state.copyWith(status: ExpenseRequestStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ExpenseRequestStatus.error));
    }
    await fetchExpenses();
  }

  Future<void> deleteExpense(int id) async {
    emit(state.copyWith(status: ExpenseRequestStatus.loading));
    try {
      await dbManager.deleteExpense(id);
      emit(state.copyWith(status: ExpenseRequestStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ExpenseRequestStatus.error));
    }
    await fetchExpenses();
  }

  Future<void> fetchExpenses() async {
    emit(state.copyWith(status: ExpenseRequestStatus.loading));

    try {
      final expenses = await dbManager.getExpenses(ascending: false);
      emit(
        state.copyWith(
          status: ExpenseRequestStatus.success,
          expenses: expenses,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: ExpenseRequestStatus.error));
    }
  }
}

@freezed
abstract class ExpenseRequestState with _$ExpenseRequestState {
  const factory ExpenseRequestState({
    required ExpenseRequestStatus status,
    required List<Expense> expenses,
  }) = _ExpenseRequestState;

  factory ExpenseRequestState.initial() =>
      ExpenseRequestState(status: ExpenseRequestStatus.initial, expenses: []);
}

enum ExpenseRequestStatus { initial, loading, success, error }
