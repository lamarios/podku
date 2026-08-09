// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_playback.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransferPlayback {

 Episode get episode; int get position; String get playerId;
/// Create a copy of TransferPlayback
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferPlaybackCopyWith<TransferPlayback> get copyWith => _$TransferPlaybackCopyWithImpl<TransferPlayback>(this as TransferPlayback, _$identity);

  /// Serializes this TransferPlayback to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferPlayback&&(identical(other.episode, episode) || other.episode == episode)&&(identical(other.position, position) || other.position == position)&&(identical(other.playerId, playerId) || other.playerId == playerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,episode,position,playerId);

@override
String toString() {
  return 'TransferPlayback(episode: $episode, position: $position, playerId: $playerId)';
}


}

/// @nodoc
abstract mixin class $TransferPlaybackCopyWith<$Res>  {
  factory $TransferPlaybackCopyWith(TransferPlayback value, $Res Function(TransferPlayback) _then) = _$TransferPlaybackCopyWithImpl;
@useResult
$Res call({
 Episode episode, int position, String playerId
});




}
/// @nodoc
class _$TransferPlaybackCopyWithImpl<$Res>
    implements $TransferPlaybackCopyWith<$Res> {
  _$TransferPlaybackCopyWithImpl(this._self, this._then);

  final TransferPlayback _self;
  final $Res Function(TransferPlayback) _then;

/// Create a copy of TransferPlayback
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? episode = null,Object? position = null,Object? playerId = null,}) {
  return _then(_self.copyWith(
episode: null == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as Episode,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TransferPlayback].
extension TransferPlaybackPatterns on TransferPlayback {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransferPlayback value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransferPlayback() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransferPlayback value)  $default,){
final _that = this;
switch (_that) {
case _TransferPlayback():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransferPlayback value)?  $default,){
final _that = this;
switch (_that) {
case _TransferPlayback() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Episode episode,  int position,  String playerId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransferPlayback() when $default != null:
return $default(_that.episode,_that.position,_that.playerId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Episode episode,  int position,  String playerId)  $default,) {final _that = this;
switch (_that) {
case _TransferPlayback():
return $default(_that.episode,_that.position,_that.playerId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Episode episode,  int position,  String playerId)?  $default,) {final _that = this;
switch (_that) {
case _TransferPlayback() when $default != null:
return $default(_that.episode,_that.position,_that.playerId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransferPlayback implements TransferPlayback {
  const _TransferPlayback({required this.episode, required this.position, required this.playerId});
  factory _TransferPlayback.fromJson(Map<String, dynamic> json) => _$TransferPlaybackFromJson(json);

@override final  Episode episode;
@override final  int position;
@override final  String playerId;

/// Create a copy of TransferPlayback
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferPlaybackCopyWith<_TransferPlayback> get copyWith => __$TransferPlaybackCopyWithImpl<_TransferPlayback>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransferPlaybackToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferPlayback&&(identical(other.episode, episode) || other.episode == episode)&&(identical(other.position, position) || other.position == position)&&(identical(other.playerId, playerId) || other.playerId == playerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,episode,position,playerId);

@override
String toString() {
  return 'TransferPlayback(episode: $episode, position: $position, playerId: $playerId)';
}


}

/// @nodoc
abstract mixin class _$TransferPlaybackCopyWith<$Res> implements $TransferPlaybackCopyWith<$Res> {
  factory _$TransferPlaybackCopyWith(_TransferPlayback value, $Res Function(_TransferPlayback) _then) = __$TransferPlaybackCopyWithImpl;
@override @useResult
$Res call({
 Episode episode, int position, String playerId
});




}
/// @nodoc
class __$TransferPlaybackCopyWithImpl<$Res>
    implements _$TransferPlaybackCopyWith<$Res> {
  __$TransferPlaybackCopyWithImpl(this._self, this._then);

  final _TransferPlayback _self;
  final $Res Function(_TransferPlayback) _then;

/// Create a copy of TransferPlayback
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? episode = null,Object? position = null,Object? playerId = null,}) {
  return _then(_TransferPlayback(
episode: null == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as Episode,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
