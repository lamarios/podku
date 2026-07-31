// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scrobbling.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScrobblingState {

 bool get holding; double? get holdingPosition;
/// Create a copy of ScrobblingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScrobblingStateCopyWith<ScrobblingState> get copyWith => _$ScrobblingStateCopyWithImpl<ScrobblingState>(this as ScrobblingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScrobblingState&&(identical(other.holding, holding) || other.holding == holding)&&(identical(other.holdingPosition, holdingPosition) || other.holdingPosition == holdingPosition));
}


@override
int get hashCode => Object.hash(runtimeType,holding,holdingPosition);

@override
String toString() {
  return 'ScrobblingState(holding: $holding, holdingPosition: $holdingPosition)';
}


}

/// @nodoc
abstract mixin class $ScrobblingStateCopyWith<$Res>  {
  factory $ScrobblingStateCopyWith(ScrobblingState value, $Res Function(ScrobblingState) _then) = _$ScrobblingStateCopyWithImpl;
@useResult
$Res call({
 bool holding, double? holdingPosition
});




}
/// @nodoc
class _$ScrobblingStateCopyWithImpl<$Res>
    implements $ScrobblingStateCopyWith<$Res> {
  _$ScrobblingStateCopyWithImpl(this._self, this._then);

  final ScrobblingState _self;
  final $Res Function(ScrobblingState) _then;

/// Create a copy of ScrobblingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? holding = null,Object? holdingPosition = freezed,}) {
  return _then(_self.copyWith(
holding: null == holding ? _self.holding : holding // ignore: cast_nullable_to_non_nullable
as bool,holdingPosition: freezed == holdingPosition ? _self.holdingPosition : holdingPosition // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScrobblingState].
extension ScrobblingStatePatterns on ScrobblingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScrobblingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScrobblingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScrobblingState value)  $default,){
final _that = this;
switch (_that) {
case _ScrobblingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScrobblingState value)?  $default,){
final _that = this;
switch (_that) {
case _ScrobblingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool holding,  double? holdingPosition)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScrobblingState() when $default != null:
return $default(_that.holding,_that.holdingPosition);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool holding,  double? holdingPosition)  $default,) {final _that = this;
switch (_that) {
case _ScrobblingState():
return $default(_that.holding,_that.holdingPosition);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool holding,  double? holdingPosition)?  $default,) {final _that = this;
switch (_that) {
case _ScrobblingState() when $default != null:
return $default(_that.holding,_that.holdingPosition);case _:
  return null;

}
}

}

/// @nodoc


class _ScrobblingState implements ScrobblingState {
  const _ScrobblingState({this.holding = false, this.holdingPosition});
  

@override@JsonKey() final  bool holding;
@override final  double? holdingPosition;

/// Create a copy of ScrobblingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScrobblingStateCopyWith<_ScrobblingState> get copyWith => __$ScrobblingStateCopyWithImpl<_ScrobblingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScrobblingState&&(identical(other.holding, holding) || other.holding == holding)&&(identical(other.holdingPosition, holdingPosition) || other.holdingPosition == holdingPosition));
}


@override
int get hashCode => Object.hash(runtimeType,holding,holdingPosition);

@override
String toString() {
  return 'ScrobblingState(holding: $holding, holdingPosition: $holdingPosition)';
}


}

/// @nodoc
abstract mixin class _$ScrobblingStateCopyWith<$Res> implements $ScrobblingStateCopyWith<$Res> {
  factory _$ScrobblingStateCopyWith(_ScrobblingState value, $Res Function(_ScrobblingState) _then) = __$ScrobblingStateCopyWithImpl;
@override @useResult
$Res call({
 bool holding, double? holdingPosition
});




}
/// @nodoc
class __$ScrobblingStateCopyWithImpl<$Res>
    implements _$ScrobblingStateCopyWith<$Res> {
  __$ScrobblingStateCopyWithImpl(this._self, this._then);

  final _ScrobblingState _self;
  final $Res Function(_ScrobblingState) _then;

/// Create a copy of ScrobblingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? holding = null,Object? holdingPosition = freezed,}) {
  return _then(_ScrobblingState(
holding: null == holding ? _self.holding : holding // ignore: cast_nullable_to_non_nullable
as bool,holdingPosition: freezed == holdingPosition ? _self.holdingPosition : holdingPosition // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
