// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ServerState {

 String? get serverUrl; dynamic get initialized; Client? get client; StackTrace? get stackTrace; bool get loading; dynamic get error; InternetConnectionStatus get status;
/// Create a copy of ServerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerStateCopyWith<ServerState> get copyWith => _$ServerStateCopyWithImpl<ServerState>(this as ServerState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ServerState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerState&&(identical(other.serverUrl, _this.serverUrl) || other.serverUrl == _this.serverUrl)&&const DeepCollectionEquality().equals(other.initialized, _this.initialized)&&(identical(other.client, _this.client) || other.client == _this.client)&&(identical(other.stackTrace, _this.stackTrace) || other.stackTrace == _this.stackTrace)&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&const DeepCollectionEquality().equals(other.error, _this.error)&&(identical(other.status, _this.status) || other.status == _this.status));
}


@override
int get hashCode {
  final _this = this as ServerState;
  return Object.hash(runtimeType,_this.serverUrl,const DeepCollectionEquality().hash(_this.initialized),_this.client,_this.stackTrace,_this.loading,const DeepCollectionEquality().hash(_this.error),_this.status);
}

@override
String toString() {
  final _this = this as ServerState;
  return 'ServerState(serverUrl: ${_this.serverUrl}, initialized: ${_this.initialized}, client: ${_this.client}, stackTrace: ${_this.stackTrace}, loading: ${_this.loading}, error: ${_this.error}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $ServerStateCopyWith<$Res>  {
  factory $ServerStateCopyWith(ServerState value, $Res Function(ServerState) _then) = _$ServerStateCopyWithImpl;
@useResult
$Res call({
 String? serverUrl, dynamic initialized, Client? client, StackTrace? stackTrace, bool loading, dynamic error, InternetConnectionStatus status
});




}
/// @nodoc
class _$ServerStateCopyWithImpl<$Res>
    implements $ServerStateCopyWith<$Res> {
  _$ServerStateCopyWithImpl(this._self, this._then);

  final ServerState _self;
  final $Res Function(ServerState) _then;

/// Create a copy of ServerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serverUrl = freezed,Object? initialized = freezed,Object? client = freezed,Object? stackTrace = freezed,Object? loading = null,Object? error = freezed,Object? status = null,}) {
  return _then(ServerState(
serverUrl: freezed == serverUrl ? _self.serverUrl : serverUrl // ignore: cast_nullable_to_non_nullable
as String?,initialized: freezed == initialized ? _self.initialized : initialized // ignore: cast_nullable_to_non_nullable
as dynamic,client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as Client?,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InternetConnectionStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [ServerState].
extension ServerStatePatterns on ServerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerState value)  $default,){
final _that = this;
switch (_that) {
case _ServerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerState value)?  $default,){
final _that = this;
switch (_that) {
case _ServerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? serverUrl,  dynamic initialized,  Client? client,  StackTrace? stackTrace,  bool loading,  dynamic error,  InternetConnectionStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerState() when $default != null:
return $default(_that.serverUrl,_that.initialized,_that.client,_that.stackTrace,_that.loading,_that.error,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? serverUrl,  dynamic initialized,  Client? client,  StackTrace? stackTrace,  bool loading,  dynamic error,  InternetConnectionStatus status)  $default,) {final _that = this;
switch (_that) {
case _ServerState():
return $default(_that.serverUrl,_that.initialized,_that.client,_that.stackTrace,_that.loading,_that.error,_that.status);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? serverUrl,  dynamic initialized,  Client? client,  StackTrace? stackTrace,  bool loading,  dynamic error,  InternetConnectionStatus status)?  $default,) {final _that = this;
switch (_that) {
case _ServerState() when $default != null:
return $default(_that.serverUrl,_that.initialized,_that.client,_that.stackTrace,_that.loading,_that.error,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _ServerState extends ServerState implements WithError {
  const _ServerState({this.serverUrl, this.initialized = false, this.client, this.stackTrace, this.loading = false, this.error, this.status = InternetConnectionStatus.connected}): super._();
  

@override final  String? serverUrl;
@override@JsonKey() final  dynamic initialized;
@override final  Client? client;
@override final  StackTrace? stackTrace;
@override@JsonKey() final  bool loading;
@override final  dynamic error;
@override@JsonKey() final  InternetConnectionStatus status;

/// Create a copy of ServerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerStateCopyWith<_ServerState> get copyWith => __$ServerStateCopyWithImpl<_ServerState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerState&&(identical(other.serverUrl, serverUrl) || other.serverUrl == serverUrl)&&const DeepCollectionEquality().equals(other.initialized, initialized)&&(identical(other.client, client) || other.client == client)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace)&&(identical(other.loading, loading) || other.loading == loading)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode {
    return Object.hash(runtimeType,serverUrl,const DeepCollectionEquality().hash(initialized),client,stackTrace,loading,const DeepCollectionEquality().hash(error),status);
}

@override
String toString() {
    return 'ServerState(serverUrl: $serverUrl, initialized: $initialized, client: $client, stackTrace: $stackTrace, loading: $loading, error: $error, status: $status)';
}


}

/// @nodoc
abstract mixin class _$ServerStateCopyWith<$Res> implements $ServerStateCopyWith<$Res> {
  factory _$ServerStateCopyWith(_ServerState value, $Res Function(_ServerState) _then) = __$ServerStateCopyWithImpl;
@override @useResult
$Res call({
 String? serverUrl, dynamic initialized, Client? client, StackTrace? stackTrace, bool loading, dynamic error, InternetConnectionStatus status
});




}
/// @nodoc
class __$ServerStateCopyWithImpl<$Res>
    implements _$ServerStateCopyWith<$Res> {
  __$ServerStateCopyWithImpl(this._self, this._then);

  final _ServerState _self;
  final $Res Function(_ServerState) _then;

/// Create a copy of ServerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serverUrl = freezed,Object? initialized = freezed,Object? client = freezed,Object? stackTrace = freezed,Object? loading = null,Object? error = freezed,Object? status = null,}) {
  return _then(_ServerState(
serverUrl: freezed == serverUrl ? _self.serverUrl : serverUrl // ignore: cast_nullable_to_non_nullable
as String?,initialized: freezed == initialized ? _self.initialized : initialized // ignore: cast_nullable_to_non_nullable
as dynamic,client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as Client?,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InternetConnectionStatus,
  ));
}


}

// dart format on
