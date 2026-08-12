// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayerStatus {

 PlayerInfo? get client; Episode? get episode; int get position; int get duration; double get speed; bool get playing; bool get broadcast; double get volume;
/// Create a copy of PlayerStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerStatusCopyWith<PlayerStatus> get copyWith => _$PlayerStatusCopyWithImpl<PlayerStatus>(this as PlayerStatus, _$identity);

  /// Serializes this PlayerStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerStatus&&(identical(other.client, client) || other.client == client)&&(identical(other.episode, episode) || other.episode == episode)&&(identical(other.position, position) || other.position == position)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.playing, playing) || other.playing == playing)&&(identical(other.broadcast, broadcast) || other.broadcast == broadcast)&&(identical(other.volume, volume) || other.volume == volume));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,client,episode,position,duration,speed,playing,broadcast,volume);

@override
String toString() {
  return 'PlayerStatus(client: $client, episode: $episode, position: $position, duration: $duration, speed: $speed, playing: $playing, broadcast: $broadcast, volume: $volume)';
}


}

/// @nodoc
abstract mixin class $PlayerStatusCopyWith<$Res>  {
  factory $PlayerStatusCopyWith(PlayerStatus value, $Res Function(PlayerStatus) _then) = _$PlayerStatusCopyWithImpl;
@useResult
$Res call({
 PlayerInfo? client, Episode? episode, int position, int duration, double speed, bool playing, bool broadcast, double volume
});


$PlayerInfoCopyWith<$Res>? get client;

}
/// @nodoc
class _$PlayerStatusCopyWithImpl<$Res>
    implements $PlayerStatusCopyWith<$Res> {
  _$PlayerStatusCopyWithImpl(this._self, this._then);

  final PlayerStatus _self;
  final $Res Function(PlayerStatus) _then;

/// Create a copy of PlayerStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? client = freezed,Object? episode = freezed,Object? position = null,Object? duration = null,Object? speed = null,Object? playing = null,Object? broadcast = null,Object? volume = null,}) {
  return _then(_self.copyWith(
client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as PlayerInfo?,episode: freezed == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as Episode?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,playing: null == playing ? _self.playing : playing // ignore: cast_nullable_to_non_nullable
as bool,broadcast: null == broadcast ? _self.broadcast : broadcast // ignore: cast_nullable_to_non_nullable
as bool,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of PlayerStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayerInfoCopyWith<$Res>? get client {
    if (_self.client == null) {
    return null;
  }

  return $PlayerInfoCopyWith<$Res>(_self.client!, (value) {
    return _then(_self.copyWith(client: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlayerStatus].
extension PlayerStatusPatterns on PlayerStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerStatus value)  $default,){
final _that = this;
switch (_that) {
case _PlayerStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerStatus value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PlayerInfo? client,  Episode? episode,  int position,  int duration,  double speed,  bool playing,  bool broadcast,  double volume)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerStatus() when $default != null:
return $default(_that.client,_that.episode,_that.position,_that.duration,_that.speed,_that.playing,_that.broadcast,_that.volume);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PlayerInfo? client,  Episode? episode,  int position,  int duration,  double speed,  bool playing,  bool broadcast,  double volume)  $default,) {final _that = this;
switch (_that) {
case _PlayerStatus():
return $default(_that.client,_that.episode,_that.position,_that.duration,_that.speed,_that.playing,_that.broadcast,_that.volume);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PlayerInfo? client,  Episode? episode,  int position,  int duration,  double speed,  bool playing,  bool broadcast,  double volume)?  $default,) {final _that = this;
switch (_that) {
case _PlayerStatus() when $default != null:
return $default(_that.client,_that.episode,_that.position,_that.duration,_that.speed,_that.playing,_that.broadcast,_that.volume);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayerStatus implements PlayerStatus {
  const _PlayerStatus({this.client, required this.episode, required this.position, required this.duration, required this.speed, this.playing = false, this.broadcast = true, this.volume = 100});
  factory _PlayerStatus.fromJson(Map<String, dynamic> json) => _$PlayerStatusFromJson(json);

@override final  PlayerInfo? client;
@override final  Episode? episode;
@override final  int position;
@override final  int duration;
@override final  double speed;
@override@JsonKey() final  bool playing;
@override@JsonKey() final  bool broadcast;
@override@JsonKey() final  double volume;

/// Create a copy of PlayerStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerStatusCopyWith<_PlayerStatus> get copyWith => __$PlayerStatusCopyWithImpl<_PlayerStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerStatusToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerStatus&&(identical(other.client, client) || other.client == client)&&(identical(other.episode, episode) || other.episode == episode)&&(identical(other.position, position) || other.position == position)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.playing, playing) || other.playing == playing)&&(identical(other.broadcast, broadcast) || other.broadcast == broadcast)&&(identical(other.volume, volume) || other.volume == volume));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,client,episode,position,duration,speed,playing,broadcast,volume);

@override
String toString() {
  return 'PlayerStatus(client: $client, episode: $episode, position: $position, duration: $duration, speed: $speed, playing: $playing, broadcast: $broadcast, volume: $volume)';
}


}

/// @nodoc
abstract mixin class _$PlayerStatusCopyWith<$Res> implements $PlayerStatusCopyWith<$Res> {
  factory _$PlayerStatusCopyWith(_PlayerStatus value, $Res Function(_PlayerStatus) _then) = __$PlayerStatusCopyWithImpl;
@override @useResult
$Res call({
 PlayerInfo? client, Episode? episode, int position, int duration, double speed, bool playing, bool broadcast, double volume
});


@override $PlayerInfoCopyWith<$Res>? get client;

}
/// @nodoc
class __$PlayerStatusCopyWithImpl<$Res>
    implements _$PlayerStatusCopyWith<$Res> {
  __$PlayerStatusCopyWithImpl(this._self, this._then);

  final _PlayerStatus _self;
  final $Res Function(_PlayerStatus) _then;

/// Create a copy of PlayerStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? client = freezed,Object? episode = freezed,Object? position = null,Object? duration = null,Object? speed = null,Object? playing = null,Object? broadcast = null,Object? volume = null,}) {
  return _then(_PlayerStatus(
client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as PlayerInfo?,episode: freezed == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as Episode?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,playing: null == playing ? _self.playing : playing // ignore: cast_nullable_to_non_nullable
as bool,broadcast: null == broadcast ? _self.broadcast : broadcast // ignore: cast_nullable_to_non_nullable
as bool,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of PlayerStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayerInfoCopyWith<$Res>? get client {
    if (_self.client == null) {
    return null;
  }

  return $PlayerInfoCopyWith<$Res>(_self.client!, (value) {
    return _then(_self.copyWith(client: value));
  });
}
}

// dart format on
