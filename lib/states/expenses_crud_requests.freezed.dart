// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expenses_crud_requests.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExpenseRequestState {

 ExpenseRequestStatus get status; List<Expense> get expenses;
/// Create a copy of ExpenseRequestState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseRequestStateCopyWith<ExpenseRequestState> get copyWith => _$ExpenseRequestStateCopyWithImpl<ExpenseRequestState>(this as ExpenseRequestState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseRequestState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.expenses, expenses));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(expenses));

@override
String toString() {
  return 'ExpenseRequestState(status: $status, expenses: $expenses)';
}


}

/// @nodoc
abstract mixin class $ExpenseRequestStateCopyWith<$Res>  {
  factory $ExpenseRequestStateCopyWith(ExpenseRequestState value, $Res Function(ExpenseRequestState) _then) = _$ExpenseRequestStateCopyWithImpl;
@useResult
$Res call({
 ExpenseRequestStatus status, List<Expense> expenses
});




}
/// @nodoc
class _$ExpenseRequestStateCopyWithImpl<$Res>
    implements $ExpenseRequestStateCopyWith<$Res> {
  _$ExpenseRequestStateCopyWithImpl(this._self, this._then);

  final ExpenseRequestState _self;
  final $Res Function(ExpenseRequestState) _then;

/// Create a copy of ExpenseRequestState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? expenses = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ExpenseRequestStatus,expenses: null == expenses ? _self.expenses : expenses // ignore: cast_nullable_to_non_nullable
as List<Expense>,
  ));
}

}


/// @nodoc


class _ExpenseRequestState implements ExpenseRequestState {
  const _ExpenseRequestState({required this.status, required final  List<Expense> expenses}): _expenses = expenses;
  

@override final  ExpenseRequestStatus status;
 final  List<Expense> _expenses;
@override List<Expense> get expenses {
  if (_expenses is EqualUnmodifiableListView) return _expenses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_expenses);
}


/// Create a copy of ExpenseRequestState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseRequestStateCopyWith<_ExpenseRequestState> get copyWith => __$ExpenseRequestStateCopyWithImpl<_ExpenseRequestState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseRequestState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._expenses, _expenses));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_expenses));

@override
String toString() {
  return 'ExpenseRequestState(status: $status, expenses: $expenses)';
}


}

/// @nodoc
abstract mixin class _$ExpenseRequestStateCopyWith<$Res> implements $ExpenseRequestStateCopyWith<$Res> {
  factory _$ExpenseRequestStateCopyWith(_ExpenseRequestState value, $Res Function(_ExpenseRequestState) _then) = __$ExpenseRequestStateCopyWithImpl;
@override @useResult
$Res call({
 ExpenseRequestStatus status, List<Expense> expenses
});




}
/// @nodoc
class __$ExpenseRequestStateCopyWithImpl<$Res>
    implements _$ExpenseRequestStateCopyWith<$Res> {
  __$ExpenseRequestStateCopyWithImpl(this._self, this._then);

  final _ExpenseRequestState _self;
  final $Res Function(_ExpenseRequestState) _then;

/// Create a copy of ExpenseRequestState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? expenses = null,}) {
  return _then(_ExpenseRequestState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ExpenseRequestStatus,expenses: null == expenses ? _self._expenses : expenses // ignore: cast_nullable_to_non_nullable
as List<Expense>,
  ));
}


}

// dart format on
