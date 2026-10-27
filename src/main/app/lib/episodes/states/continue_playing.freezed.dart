// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'continue_playing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ContinuePlayingState {

 List<Episode> get episodes; bool get loading;
/// Create a copy of ContinuePlayingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContinuePlayingStateCopyWith<ContinuePlayingState> get copyWith => _$ContinuePlayingStateCopyWithImpl<ContinuePlayingState>(this as ContinuePlayingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContinuePlayingState&&const DeepCollectionEquality().equals(other.episodes, episodes)&&(identical(other.loading, loading) || other.loading == loading));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(episodes),loading);

@override
String toString() {
  return 'ContinuePlayingState(episodes: $episodes, loading: $loading)';
}


}

/// @nodoc
abstract mixin class $ContinuePlayingStateCopyWith<$Res>  {
  factory $ContinuePlayingStateCopyWith(ContinuePlayingState value, $Res Function(ContinuePlayingState) _then) = _$ContinuePlayingStateCopyWithImpl;
@useResult
$Res call({
 List<Episode> episodes, bool loading
});




}
/// @nodoc
class _$ContinuePlayingStateCopyWithImpl<$Res>
    implements $ContinuePlayingStateCopyWith<$Res> {
  _$ContinuePlayingStateCopyWithImpl(this._self, this._then);

  final ContinuePlayingState _self;
  final $Res Function(ContinuePlayingState) _then;

/// Create a copy of ContinuePlayingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? episodes = null,Object? loading = null,}) {
  return _then(_self.copyWith(
episodes: null == episodes ? _self.episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<Episode>,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ContinuePlayingState].
extension ContinuePlayingStatePatterns on ContinuePlayingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContinuePlayingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContinuePlayingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContinuePlayingState value)  $default,){
final _that = this;
switch (_that) {
case _ContinuePlayingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContinuePlayingState value)?  $default,){
final _that = this;
switch (_that) {
case _ContinuePlayingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Episode> episodes,  bool loading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContinuePlayingState() when $default != null:
return $default(_that.episodes,_that.loading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Episode> episodes,  bool loading)  $default,) {final _that = this;
switch (_that) {
case _ContinuePlayingState():
return $default(_that.episodes,_that.loading);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Episode> episodes,  bool loading)?  $default,) {final _that = this;
switch (_that) {
case _ContinuePlayingState() when $default != null:
return $default(_that.episodes,_that.loading);case _:
  return null;

}
}

}

/// @nodoc


class _ContinuePlayingState implements ContinuePlayingState {
  const _ContinuePlayingState({final  List<Episode> episodes = const [], this.loading = true}): _episodes = episodes;
  

 final  List<Episode> _episodes;
@override@JsonKey() List<Episode> get episodes {
  if (_episodes is EqualUnmodifiableListView) return _episodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_episodes);
}

@override@JsonKey() final  bool loading;

/// Create a copy of ContinuePlayingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContinuePlayingStateCopyWith<_ContinuePlayingState> get copyWith => __$ContinuePlayingStateCopyWithImpl<_ContinuePlayingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContinuePlayingState&&const DeepCollectionEquality().equals(other._episodes, _episodes)&&(identical(other.loading, loading) || other.loading == loading));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_episodes),loading);

@override
String toString() {
  return 'ContinuePlayingState(episodes: $episodes, loading: $loading)';
}


}

/// @nodoc
abstract mixin class _$ContinuePlayingStateCopyWith<$Res> implements $ContinuePlayingStateCopyWith<$Res> {
  factory _$ContinuePlayingStateCopyWith(_ContinuePlayingState value, $Res Function(_ContinuePlayingState) _then) = __$ContinuePlayingStateCopyWithImpl;
@override @useResult
$Res call({
 List<Episode> episodes, bool loading
});




}
/// @nodoc
class __$ContinuePlayingStateCopyWithImpl<$Res>
    implements _$ContinuePlayingStateCopyWith<$Res> {
  __$ContinuePlayingStateCopyWithImpl(this._self, this._then);

  final _ContinuePlayingState _self;
  final $Res Function(_ContinuePlayingState) _then;

/// Create a copy of ContinuePlayingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? episodes = null,Object? loading = null,}) {
  return _then(_ContinuePlayingState(
episodes: null == episodes ? _self._episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<Episode>,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
