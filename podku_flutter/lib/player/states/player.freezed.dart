// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlayerState implements DiagnosticableTreeMixin {

 bool get loading; Episode? get episode; Duration get position; Duration get bufferPosition; Duration get duration; bool get playing; bool get showMiniPlayer; bool get showBigPlayer;
/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerStateCopyWith<PlayerState> get copyWith => _$PlayerStateCopyWithImpl<PlayerState>(this as PlayerState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'PlayerState'))
    ..add(DiagnosticsProperty('loading', loading))..add(DiagnosticsProperty('episode', episode))..add(DiagnosticsProperty('position', position))..add(DiagnosticsProperty('bufferPosition', bufferPosition))..add(DiagnosticsProperty('duration', duration))..add(DiagnosticsProperty('playing', playing))..add(DiagnosticsProperty('showMiniPlayer', showMiniPlayer))..add(DiagnosticsProperty('showBigPlayer', showBigPlayer));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.episode, episode) || other.episode == episode)&&(identical(other.position, position) || other.position == position)&&(identical(other.bufferPosition, bufferPosition) || other.bufferPosition == bufferPosition)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.playing, playing) || other.playing == playing)&&(identical(other.showMiniPlayer, showMiniPlayer) || other.showMiniPlayer == showMiniPlayer)&&(identical(other.showBigPlayer, showBigPlayer) || other.showBigPlayer == showBigPlayer));
}


@override
int get hashCode => Object.hash(runtimeType,loading,episode,position,bufferPosition,duration,playing,showMiniPlayer,showBigPlayer);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'PlayerState(loading: $loading, episode: $episode, position: $position, bufferPosition: $bufferPosition, duration: $duration, playing: $playing, showMiniPlayer: $showMiniPlayer, showBigPlayer: $showBigPlayer)';
}


}

/// @nodoc
abstract mixin class $PlayerStateCopyWith<$Res>  {
  factory $PlayerStateCopyWith(PlayerState value, $Res Function(PlayerState) _then) = _$PlayerStateCopyWithImpl;
@useResult
$Res call({
 bool loading, Episode? episode, Duration position, Duration bufferPosition, Duration duration, bool playing, bool showMiniPlayer, bool showBigPlayer
});




}
/// @nodoc
class _$PlayerStateCopyWithImpl<$Res>
    implements $PlayerStateCopyWith<$Res> {
  _$PlayerStateCopyWithImpl(this._self, this._then);

  final PlayerState _self;
  final $Res Function(PlayerState) _then;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? episode = freezed,Object? position = null,Object? bufferPosition = null,Object? duration = null,Object? playing = null,Object? showMiniPlayer = null,Object? showBigPlayer = null,}) {
  return _then(_self.copyWith(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,episode: freezed == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as Episode?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,bufferPosition: null == bufferPosition ? _self.bufferPosition : bufferPosition // ignore: cast_nullable_to_non_nullable
as Duration,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,playing: null == playing ? _self.playing : playing // ignore: cast_nullable_to_non_nullable
as bool,showMiniPlayer: null == showMiniPlayer ? _self.showMiniPlayer : showMiniPlayer // ignore: cast_nullable_to_non_nullable
as bool,showBigPlayer: null == showBigPlayer ? _self.showBigPlayer : showBigPlayer // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayerState].
extension PlayerStatePatterns on PlayerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerState value)  $default,){
final _that = this;
switch (_that) {
case _PlayerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerState value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  Episode? episode,  Duration position,  Duration bufferPosition,  Duration duration,  bool playing,  bool showMiniPlayer,  bool showBigPlayer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that.loading,_that.episode,_that.position,_that.bufferPosition,_that.duration,_that.playing,_that.showMiniPlayer,_that.showBigPlayer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  Episode? episode,  Duration position,  Duration bufferPosition,  Duration duration,  bool playing,  bool showMiniPlayer,  bool showBigPlayer)  $default,) {final _that = this;
switch (_that) {
case _PlayerState():
return $default(_that.loading,_that.episode,_that.position,_that.bufferPosition,_that.duration,_that.playing,_that.showMiniPlayer,_that.showBigPlayer);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  Episode? episode,  Duration position,  Duration bufferPosition,  Duration duration,  bool playing,  bool showMiniPlayer,  bool showBigPlayer)?  $default,) {final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that.loading,_that.episode,_that.position,_that.bufferPosition,_that.duration,_that.playing,_that.showMiniPlayer,_that.showBigPlayer);case _:
  return null;

}
}

}

/// @nodoc


class _PlayerState with DiagnosticableTreeMixin implements PlayerState {
  const _PlayerState({this.loading = false, this.episode, this.position = const Duration(seconds: 0), this.bufferPosition = const Duration(seconds: 0), this.duration = const Duration(seconds: 1), this.playing = false, this.showMiniPlayer = false, this.showBigPlayer = false});
  

@override@JsonKey() final  bool loading;
@override final  Episode? episode;
@override@JsonKey() final  Duration position;
@override@JsonKey() final  Duration bufferPosition;
@override@JsonKey() final  Duration duration;
@override@JsonKey() final  bool playing;
@override@JsonKey() final  bool showMiniPlayer;
@override@JsonKey() final  bool showBigPlayer;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerStateCopyWith<_PlayerState> get copyWith => __$PlayerStateCopyWithImpl<_PlayerState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'PlayerState'))
    ..add(DiagnosticsProperty('loading', loading))..add(DiagnosticsProperty('episode', episode))..add(DiagnosticsProperty('position', position))..add(DiagnosticsProperty('bufferPosition', bufferPosition))..add(DiagnosticsProperty('duration', duration))..add(DiagnosticsProperty('playing', playing))..add(DiagnosticsProperty('showMiniPlayer', showMiniPlayer))..add(DiagnosticsProperty('showBigPlayer', showBigPlayer));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.episode, episode) || other.episode == episode)&&(identical(other.position, position) || other.position == position)&&(identical(other.bufferPosition, bufferPosition) || other.bufferPosition == bufferPosition)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.playing, playing) || other.playing == playing)&&(identical(other.showMiniPlayer, showMiniPlayer) || other.showMiniPlayer == showMiniPlayer)&&(identical(other.showBigPlayer, showBigPlayer) || other.showBigPlayer == showBigPlayer));
}


@override
int get hashCode => Object.hash(runtimeType,loading,episode,position,bufferPosition,duration,playing,showMiniPlayer,showBigPlayer);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'PlayerState(loading: $loading, episode: $episode, position: $position, bufferPosition: $bufferPosition, duration: $duration, playing: $playing, showMiniPlayer: $showMiniPlayer, showBigPlayer: $showBigPlayer)';
}


}

/// @nodoc
abstract mixin class _$PlayerStateCopyWith<$Res> implements $PlayerStateCopyWith<$Res> {
  factory _$PlayerStateCopyWith(_PlayerState value, $Res Function(_PlayerState) _then) = __$PlayerStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, Episode? episode, Duration position, Duration bufferPosition, Duration duration, bool playing, bool showMiniPlayer, bool showBigPlayer
});




}
/// @nodoc
class __$PlayerStateCopyWithImpl<$Res>
    implements _$PlayerStateCopyWith<$Res> {
  __$PlayerStateCopyWithImpl(this._self, this._then);

  final _PlayerState _self;
  final $Res Function(_PlayerState) _then;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? episode = freezed,Object? position = null,Object? bufferPosition = null,Object? duration = null,Object? playing = null,Object? showMiniPlayer = null,Object? showBigPlayer = null,}) {
  return _then(_PlayerState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,episode: freezed == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as Episode?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,bufferPosition: null == bufferPosition ? _self.bufferPosition : bufferPosition // ignore: cast_nullable_to_non_nullable
as Duration,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,playing: null == playing ? _self.playing : playing // ignore: cast_nullable_to_non_nullable
as bool,showMiniPlayer: null == showMiniPlayer ? _self.showMiniPlayer : showMiniPlayer // ignore: cast_nullable_to_non_nullable
as bool,showBigPlayer: null == showBigPlayer ? _self.showBigPlayer : showBigPlayer // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
