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
mixin _$EpisodeState {

 bool get loading; List<Episode> get episodes; int? get cursor;
/// Create a copy of EpisodeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EpisodeStateCopyWith<EpisodeState> get copyWith => _$EpisodeStateCopyWithImpl<EpisodeState>(this as EpisodeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EpisodeState&&(identical(other.loading, loading) || other.loading == loading)&&const DeepCollectionEquality().equals(other.episodes, episodes)&&(identical(other.cursor, cursor) || other.cursor == cursor));
}


@override
int get hashCode => Object.hash(runtimeType,loading,const DeepCollectionEquality().hash(episodes),cursor);

@override
String toString() {
  return 'EpisodeState(loading: $loading, episodes: $episodes, cursor: $cursor)';
}


}

/// @nodoc
abstract mixin class $EpisodeStateCopyWith<$Res>  {
  factory $EpisodeStateCopyWith(EpisodeState value, $Res Function(EpisodeState) _then) = _$EpisodeStateCopyWithImpl;
@useResult
$Res call({
 bool loading, List<Episode> episodes, int? cursor
});




}
/// @nodoc
class _$EpisodeStateCopyWithImpl<$Res>
    implements $EpisodeStateCopyWith<$Res> {
  _$EpisodeStateCopyWithImpl(this._self, this._then);

  final EpisodeState _self;
  final $Res Function(EpisodeState) _then;

/// Create a copy of EpisodeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? episodes = null,Object? cursor = freezed,}) {
  return _then(_self.copyWith(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,episodes: null == episodes ? _self.episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<Episode>,cursor: freezed == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [EpisodeState].
extension EpisodeStatePatterns on EpisodeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EpisodeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EpisodeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EpisodeState value)  $default,){
final _that = this;
switch (_that) {
case _EpisodeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EpisodeState value)?  $default,){
final _that = this;
switch (_that) {
case _EpisodeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  List<Episode> episodes,  int? cursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EpisodeState() when $default != null:
return $default(_that.loading,_that.episodes,_that.cursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  List<Episode> episodes,  int? cursor)  $default,) {final _that = this;
switch (_that) {
case _EpisodeState():
return $default(_that.loading,_that.episodes,_that.cursor);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  List<Episode> episodes,  int? cursor)?  $default,) {final _that = this;
switch (_that) {
case _EpisodeState() when $default != null:
return $default(_that.loading,_that.episodes,_that.cursor);case _:
  return null;

}
}

}

/// @nodoc


class _EpisodeState implements EpisodeState {
  const _EpisodeState({this.loading = false, final  List<Episode> episodes = const [], this.cursor}): _episodes = episodes;
  

@override@JsonKey() final  bool loading;
 final  List<Episode> _episodes;
@override@JsonKey() List<Episode> get episodes {
  if (_episodes is EqualUnmodifiableListView) return _episodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_episodes);
}

@override final  int? cursor;

/// Create a copy of EpisodeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EpisodeStateCopyWith<_EpisodeState> get copyWith => __$EpisodeStateCopyWithImpl<_EpisodeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EpisodeState&&(identical(other.loading, loading) || other.loading == loading)&&const DeepCollectionEquality().equals(other._episodes, _episodes)&&(identical(other.cursor, cursor) || other.cursor == cursor));
}


@override
int get hashCode => Object.hash(runtimeType,loading,const DeepCollectionEquality().hash(_episodes),cursor);

@override
String toString() {
  return 'EpisodeState(loading: $loading, episodes: $episodes, cursor: $cursor)';
}


}

/// @nodoc
abstract mixin class _$EpisodeStateCopyWith<$Res> implements $EpisodeStateCopyWith<$Res> {
  factory _$EpisodeStateCopyWith(_EpisodeState value, $Res Function(_EpisodeState) _then) = __$EpisodeStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, List<Episode> episodes, int? cursor
});




}
/// @nodoc
class __$EpisodeStateCopyWithImpl<$Res>
    implements _$EpisodeStateCopyWith<$Res> {
  __$EpisodeStateCopyWithImpl(this._self, this._then);

  final _EpisodeState _self;
  final $Res Function(_EpisodeState) _then;

/// Create a copy of EpisodeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? episodes = null,Object? cursor = freezed,}) {
  return _then(_EpisodeState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,episodes: null == episodes ? _self._episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<Episode>,cursor: freezed == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
