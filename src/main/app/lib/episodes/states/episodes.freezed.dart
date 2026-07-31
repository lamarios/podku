// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'episodes.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EpisodesState {

 bool get loading; List<Episode> get episodes; int? get cursor; dynamic get error; StackTrace? get stackTrace;
/// Create a copy of EpisodesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EpisodesStateCopyWith<EpisodesState> get copyWith => _$EpisodesStateCopyWithImpl<EpisodesState>(this as EpisodesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EpisodesState&&(identical(other.loading, loading) || other.loading == loading)&&const DeepCollectionEquality().equals(other.episodes, episodes)&&(identical(other.cursor, cursor) || other.cursor == cursor)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,loading,const DeepCollectionEquality().hash(episodes),cursor,const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'EpisodesState(loading: $loading, episodes: $episodes, cursor: $cursor, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $EpisodesStateCopyWith<$Res>  {
  factory $EpisodesStateCopyWith(EpisodesState value, $Res Function(EpisodesState) _then) = _$EpisodesStateCopyWithImpl;
@useResult
$Res call({
 bool loading, List<Episode> episodes, int? cursor, dynamic error, StackTrace? stackTrace
});




}
/// @nodoc
class _$EpisodesStateCopyWithImpl<$Res>
    implements $EpisodesStateCopyWith<$Res> {
  _$EpisodesStateCopyWithImpl(this._self, this._then);

  final EpisodesState _self;
  final $Res Function(EpisodesState) _then;

/// Create a copy of EpisodesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? episodes = null,Object? cursor = freezed,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(_self.copyWith(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,episodes: null == episodes ? _self.episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<Episode>,cursor: freezed == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as int?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}

}


/// Adds pattern-matching-related methods to [EpisodesState].
extension EpisodesStatePatterns on EpisodesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EpisodesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EpisodesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EpisodesState value)  $default,){
final _that = this;
switch (_that) {
case _EpisodesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EpisodesState value)?  $default,){
final _that = this;
switch (_that) {
case _EpisodesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  List<Episode> episodes,  int? cursor,  dynamic error,  StackTrace? stackTrace)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EpisodesState() when $default != null:
return $default(_that.loading,_that.episodes,_that.cursor,_that.error,_that.stackTrace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  List<Episode> episodes,  int? cursor,  dynamic error,  StackTrace? stackTrace)  $default,) {final _that = this;
switch (_that) {
case _EpisodesState():
return $default(_that.loading,_that.episodes,_that.cursor,_that.error,_that.stackTrace);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  List<Episode> episodes,  int? cursor,  dynamic error,  StackTrace? stackTrace)?  $default,) {final _that = this;
switch (_that) {
case _EpisodesState() when $default != null:
return $default(_that.loading,_that.episodes,_that.cursor,_that.error,_that.stackTrace);case _:
  return null;

}
}

}

/// @nodoc


class _EpisodesState implements EpisodesState, WithError {
  const _EpisodesState({this.loading = false, final  List<Episode> episodes = const [], this.cursor, this.error, this.stackTrace}): _episodes = episodes;
  

@override@JsonKey() final  bool loading;
 final  List<Episode> _episodes;
@override@JsonKey() List<Episode> get episodes {
  if (_episodes is EqualUnmodifiableListView) return _episodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_episodes);
}

@override final  int? cursor;
@override final  dynamic error;
@override final  StackTrace? stackTrace;

/// Create a copy of EpisodesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EpisodesStateCopyWith<_EpisodesState> get copyWith => __$EpisodesStateCopyWithImpl<_EpisodesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EpisodesState&&(identical(other.loading, loading) || other.loading == loading)&&const DeepCollectionEquality().equals(other._episodes, _episodes)&&(identical(other.cursor, cursor) || other.cursor == cursor)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,loading,const DeepCollectionEquality().hash(_episodes),cursor,const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'EpisodesState(loading: $loading, episodes: $episodes, cursor: $cursor, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class _$EpisodesStateCopyWith<$Res> implements $EpisodesStateCopyWith<$Res> {
  factory _$EpisodesStateCopyWith(_EpisodesState value, $Res Function(_EpisodesState) _then) = __$EpisodesStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, List<Episode> episodes, int? cursor, dynamic error, StackTrace? stackTrace
});




}
/// @nodoc
class __$EpisodesStateCopyWithImpl<$Res>
    implements _$EpisodesStateCopyWith<$Res> {
  __$EpisodesStateCopyWithImpl(this._self, this._then);

  final _EpisodesState _self;
  final $Res Function(_EpisodesState) _then;

/// Create a copy of EpisodesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? episodes = null,Object? cursor = freezed,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(_EpisodesState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,episodes: null == episodes ? _self._episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<Episode>,cursor: freezed == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as int?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

// dart format on
