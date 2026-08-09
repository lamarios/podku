// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'client_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ClientList {

 List<PlayerInfo> get clients;
/// Create a copy of ClientList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClientListCopyWith<ClientList> get copyWith => _$ClientListCopyWithImpl<ClientList>(this as ClientList, _$identity);

  /// Serializes this ClientList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClientList&&const DeepCollectionEquality().equals(other.clients, clients));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(clients));

@override
String toString() {
  return 'ClientList(clients: $clients)';
}


}

/// @nodoc
abstract mixin class $ClientListCopyWith<$Res>  {
  factory $ClientListCopyWith(ClientList value, $Res Function(ClientList) _then) = _$ClientListCopyWithImpl;
@useResult
$Res call({
 List<PlayerInfo> clients
});




}
/// @nodoc
class _$ClientListCopyWithImpl<$Res>
    implements $ClientListCopyWith<$Res> {
  _$ClientListCopyWithImpl(this._self, this._then);

  final ClientList _self;
  final $Res Function(ClientList) _then;

/// Create a copy of ClientList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? clients = null,}) {
  return _then(_self.copyWith(
clients: null == clients ? _self.clients : clients // ignore: cast_nullable_to_non_nullable
as List<PlayerInfo>,
  ));
}

}


/// Adds pattern-matching-related methods to [ClientList].
extension ClientListPatterns on ClientList {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClientList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClientList() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClientList value)  $default,){
final _that = this;
switch (_that) {
case _ClientList():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClientList value)?  $default,){
final _that = this;
switch (_that) {
case _ClientList() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PlayerInfo> clients)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClientList() when $default != null:
return $default(_that.clients);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PlayerInfo> clients)  $default,) {final _that = this;
switch (_that) {
case _ClientList():
return $default(_that.clients);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PlayerInfo> clients)?  $default,) {final _that = this;
switch (_that) {
case _ClientList() when $default != null:
return $default(_that.clients);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClientList implements ClientList {
  const _ClientList({final  List<PlayerInfo> clients = const []}): _clients = clients;
  factory _ClientList.fromJson(Map<String, dynamic> json) => _$ClientListFromJson(json);

 final  List<PlayerInfo> _clients;
@override@JsonKey() List<PlayerInfo> get clients {
  if (_clients is EqualUnmodifiableListView) return _clients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_clients);
}


/// Create a copy of ClientList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClientListCopyWith<_ClientList> get copyWith => __$ClientListCopyWithImpl<_ClientList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClientListToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClientList&&const DeepCollectionEquality().equals(other._clients, _clients));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_clients));

@override
String toString() {
  return 'ClientList(clients: $clients)';
}


}

/// @nodoc
abstract mixin class _$ClientListCopyWith<$Res> implements $ClientListCopyWith<$Res> {
  factory _$ClientListCopyWith(_ClientList value, $Res Function(_ClientList) _then) = __$ClientListCopyWithImpl;
@override @useResult
$Res call({
 List<PlayerInfo> clients
});




}
/// @nodoc
class __$ClientListCopyWithImpl<$Res>
    implements _$ClientListCopyWith<$Res> {
  __$ClientListCopyWithImpl(this._self, this._then);

  final _ClientList _self;
  final $Res Function(_ClientList) _then;

/// Create a copy of ClientList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? clients = null,}) {
  return _then(_ClientList(
clients: null == clients ? _self._clients : clients // ignore: cast_nullable_to_non_nullable
as List<PlayerInfo>,
  ));
}


}

// dart format on
