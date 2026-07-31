// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'download_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DownloadSettingsState {

 bool get downloadAutomatically; int get podcastEpisodes;
/// Create a copy of DownloadSettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DownloadSettingsStateCopyWith<DownloadSettingsState> get copyWith => _$DownloadSettingsStateCopyWithImpl<DownloadSettingsState>(this as DownloadSettingsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadSettingsState&&(identical(other.downloadAutomatically, downloadAutomatically) || other.downloadAutomatically == downloadAutomatically)&&(identical(other.podcastEpisodes, podcastEpisodes) || other.podcastEpisodes == podcastEpisodes));
}


@override
int get hashCode => Object.hash(runtimeType,downloadAutomatically,podcastEpisodes);

@override
String toString() {
  return 'DownloadSettingsState(downloadAutomatically: $downloadAutomatically, podcastEpisodes: $podcastEpisodes)';
}


}

/// @nodoc
abstract mixin class $DownloadSettingsStateCopyWith<$Res>  {
  factory $DownloadSettingsStateCopyWith(DownloadSettingsState value, $Res Function(DownloadSettingsState) _then) = _$DownloadSettingsStateCopyWithImpl;
@useResult
$Res call({
 bool downloadAutomatically, int podcastEpisodes
});




}
/// @nodoc
class _$DownloadSettingsStateCopyWithImpl<$Res>
    implements $DownloadSettingsStateCopyWith<$Res> {
  _$DownloadSettingsStateCopyWithImpl(this._self, this._then);

  final DownloadSettingsState _self;
  final $Res Function(DownloadSettingsState) _then;

/// Create a copy of DownloadSettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? downloadAutomatically = null,Object? podcastEpisodes = null,}) {
  return _then(_self.copyWith(
downloadAutomatically: null == downloadAutomatically ? _self.downloadAutomatically : downloadAutomatically // ignore: cast_nullable_to_non_nullable
as bool,podcastEpisodes: null == podcastEpisodes ? _self.podcastEpisodes : podcastEpisodes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DownloadSettingsState].
extension DownloadSettingsStatePatterns on DownloadSettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DownloadSettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DownloadSettingsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DownloadSettingsState value)  $default,){
final _that = this;
switch (_that) {
case _DownloadSettingsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DownloadSettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _DownloadSettingsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool downloadAutomatically,  int podcastEpisodes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DownloadSettingsState() when $default != null:
return $default(_that.downloadAutomatically,_that.podcastEpisodes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool downloadAutomatically,  int podcastEpisodes)  $default,) {final _that = this;
switch (_that) {
case _DownloadSettingsState():
return $default(_that.downloadAutomatically,_that.podcastEpisodes);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool downloadAutomatically,  int podcastEpisodes)?  $default,) {final _that = this;
switch (_that) {
case _DownloadSettingsState() when $default != null:
return $default(_that.downloadAutomatically,_that.podcastEpisodes);case _:
  return null;

}
}

}

/// @nodoc


class _DownloadSettingsState implements DownloadSettingsState {
  const _DownloadSettingsState({this.downloadAutomatically = false, this.podcastEpisodes = 2});
  

@override@JsonKey() final  bool downloadAutomatically;
@override@JsonKey() final  int podcastEpisodes;

/// Create a copy of DownloadSettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DownloadSettingsStateCopyWith<_DownloadSettingsState> get copyWith => __$DownloadSettingsStateCopyWithImpl<_DownloadSettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DownloadSettingsState&&(identical(other.downloadAutomatically, downloadAutomatically) || other.downloadAutomatically == downloadAutomatically)&&(identical(other.podcastEpisodes, podcastEpisodes) || other.podcastEpisodes == podcastEpisodes));
}


@override
int get hashCode => Object.hash(runtimeType,downloadAutomatically,podcastEpisodes);

@override
String toString() {
  return 'DownloadSettingsState(downloadAutomatically: $downloadAutomatically, podcastEpisodes: $podcastEpisodes)';
}


}

/// @nodoc
abstract mixin class _$DownloadSettingsStateCopyWith<$Res> implements $DownloadSettingsStateCopyWith<$Res> {
  factory _$DownloadSettingsStateCopyWith(_DownloadSettingsState value, $Res Function(_DownloadSettingsState) _then) = __$DownloadSettingsStateCopyWithImpl;
@override @useResult
$Res call({
 bool downloadAutomatically, int podcastEpisodes
});




}
/// @nodoc
class __$DownloadSettingsStateCopyWithImpl<$Res>
    implements _$DownloadSettingsStateCopyWith<$Res> {
  __$DownloadSettingsStateCopyWithImpl(this._self, this._then);

  final _DownloadSettingsState _self;
  final $Res Function(_DownloadSettingsState) _then;

/// Create a copy of DownloadSettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? downloadAutomatically = null,Object? podcastEpisodes = null,}) {
  return _then(_DownloadSettingsState(
downloadAutomatically: null == downloadAutomatically ? _self.downloadAutomatically : downloadAutomatically // ignore: cast_nullable_to_non_nullable
as bool,podcastEpisodes: null == podcastEpisodes ? _self.podcastEpisodes : podcastEpisodes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
