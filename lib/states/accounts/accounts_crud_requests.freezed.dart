// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounts_crud_requests.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountRequestState {

 AccountRequestStatus get status; List<Account> get accounts;
/// Create a copy of AccountRequestState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountRequestStateCopyWith<AccountRequestState> get copyWith => _$AccountRequestStateCopyWithImpl<AccountRequestState>(this as AccountRequestState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountRequestState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.accounts, accounts));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(accounts));

@override
String toString() {
  return 'AccountRequestState(status: $status, accounts: $accounts)';
}


}

/// @nodoc
abstract mixin class $AccountRequestStateCopyWith<$Res>  {
  factory $AccountRequestStateCopyWith(AccountRequestState value, $Res Function(AccountRequestState) _then) = _$AccountRequestStateCopyWithImpl;
@useResult
$Res call({
 AccountRequestStatus status, List<Account> accounts
});




}
/// @nodoc
class _$AccountRequestStateCopyWithImpl<$Res>
    implements $AccountRequestStateCopyWith<$Res> {
  _$AccountRequestStateCopyWithImpl(this._self, this._then);

  final AccountRequestState _self;
  final $Res Function(AccountRequestState) _then;

/// Create a copy of AccountRequestState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? accounts = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AccountRequestStatus,accounts: null == accounts ? _self.accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<Account>,
  ));
}

}


/// @nodoc


class _AccountRequestState implements AccountRequestState {
  const _AccountRequestState({required this.status, required final  List<Account> accounts}): _accounts = accounts;
  

@override final  AccountRequestStatus status;
 final  List<Account> _accounts;
@override List<Account> get accounts {
  if (_accounts is EqualUnmodifiableListView) return _accounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_accounts);
}


/// Create a copy of AccountRequestState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountRequestStateCopyWith<_AccountRequestState> get copyWith => __$AccountRequestStateCopyWithImpl<_AccountRequestState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountRequestState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._accounts, _accounts));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_accounts));

@override
String toString() {
  return 'AccountRequestState(status: $status, accounts: $accounts)';
}


}

/// @nodoc
abstract mixin class _$AccountRequestStateCopyWith<$Res> implements $AccountRequestStateCopyWith<$Res> {
  factory _$AccountRequestStateCopyWith(_AccountRequestState value, $Res Function(_AccountRequestState) _then) = __$AccountRequestStateCopyWithImpl;
@override @useResult
$Res call({
 AccountRequestStatus status, List<Account> accounts
});




}
/// @nodoc
class __$AccountRequestStateCopyWithImpl<$Res>
    implements _$AccountRequestStateCopyWith<$Res> {
  __$AccountRequestStateCopyWithImpl(this._self, this._then);

  final _AccountRequestState _self;
  final $Res Function(_AccountRequestState) _then;

/// Create a copy of AccountRequestState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? accounts = null,}) {
  return _then(_AccountRequestState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AccountRequestStatus,accounts: null == accounts ? _self._accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<Account>,
  ));
}


}

// dart format on
