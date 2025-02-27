// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatState {

 SendMessageStatus get sendMessageStatus; List<ChatMessage> get messages; List<Expense> get selectedExpenses;
/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatStateCopyWith<ChatState> get copyWith => _$ChatStateCopyWithImpl<ChatState>(this as ChatState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatState&&(identical(other.sendMessageStatus, sendMessageStatus) || other.sendMessageStatus == sendMessageStatus)&&const DeepCollectionEquality().equals(other.messages, messages)&&const DeepCollectionEquality().equals(other.selectedExpenses, selectedExpenses));
}


@override
int get hashCode => Object.hash(runtimeType,sendMessageStatus,const DeepCollectionEquality().hash(messages),const DeepCollectionEquality().hash(selectedExpenses));

@override
String toString() {
  return 'ChatState(sendMessageStatus: $sendMessageStatus, messages: $messages, selectedExpenses: $selectedExpenses)';
}


}

/// @nodoc
abstract mixin class $ChatStateCopyWith<$Res>  {
  factory $ChatStateCopyWith(ChatState value, $Res Function(ChatState) _then) = _$ChatStateCopyWithImpl;
@useResult
$Res call({
 SendMessageStatus sendMessageStatus, List<ChatMessage> messages, List<Expense> selectedExpenses
});




}
/// @nodoc
class _$ChatStateCopyWithImpl<$Res>
    implements $ChatStateCopyWith<$Res> {
  _$ChatStateCopyWithImpl(this._self, this._then);

  final ChatState _self;
  final $Res Function(ChatState) _then;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sendMessageStatus = null,Object? messages = null,Object? selectedExpenses = null,}) {
  return _then(_self.copyWith(
sendMessageStatus: null == sendMessageStatus ? _self.sendMessageStatus : sendMessageStatus // ignore: cast_nullable_to_non_nullable
as SendMessageStatus,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,selectedExpenses: null == selectedExpenses ? _self.selectedExpenses : selectedExpenses // ignore: cast_nullable_to_non_nullable
as List<Expense>,
  ));
}

}


/// @nodoc


class _ChatState extends ChatState {
  const _ChatState({required this.sendMessageStatus, required final  List<ChatMessage> messages, required final  List<Expense> selectedExpenses}): _messages = messages,_selectedExpenses = selectedExpenses,super._();
  

@override final  SendMessageStatus sendMessageStatus;
 final  List<ChatMessage> _messages;
@override List<ChatMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

 final  List<Expense> _selectedExpenses;
@override List<Expense> get selectedExpenses {
  if (_selectedExpenses is EqualUnmodifiableListView) return _selectedExpenses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedExpenses);
}


/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatStateCopyWith<_ChatState> get copyWith => __$ChatStateCopyWithImpl<_ChatState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatState&&(identical(other.sendMessageStatus, sendMessageStatus) || other.sendMessageStatus == sendMessageStatus)&&const DeepCollectionEquality().equals(other._messages, _messages)&&const DeepCollectionEquality().equals(other._selectedExpenses, _selectedExpenses));
}


@override
int get hashCode => Object.hash(runtimeType,sendMessageStatus,const DeepCollectionEquality().hash(_messages),const DeepCollectionEquality().hash(_selectedExpenses));

@override
String toString() {
  return 'ChatState(sendMessageStatus: $sendMessageStatus, messages: $messages, selectedExpenses: $selectedExpenses)';
}


}

/// @nodoc
abstract mixin class _$ChatStateCopyWith<$Res> implements $ChatStateCopyWith<$Res> {
  factory _$ChatStateCopyWith(_ChatState value, $Res Function(_ChatState) _then) = __$ChatStateCopyWithImpl;
@override @useResult
$Res call({
 SendMessageStatus sendMessageStatus, List<ChatMessage> messages, List<Expense> selectedExpenses
});




}
/// @nodoc
class __$ChatStateCopyWithImpl<$Res>
    implements _$ChatStateCopyWith<$Res> {
  __$ChatStateCopyWithImpl(this._self, this._then);

  final _ChatState _self;
  final $Res Function(_ChatState) _then;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sendMessageStatus = null,Object? messages = null,Object? selectedExpenses = null,}) {
  return _then(_ChatState(
sendMessageStatus: null == sendMessageStatus ? _self.sendMessageStatus : sendMessageStatus // ignore: cast_nullable_to_non_nullable
as SendMessageStatus,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,selectedExpenses: null == selectedExpenses ? _self._selectedExpenses : selectedExpenses // ignore: cast_nullable_to_non_nullable
as List<Expense>,
  ));
}


}

// dart format on
