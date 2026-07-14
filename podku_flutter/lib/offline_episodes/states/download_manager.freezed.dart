// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'download_manager.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DownloadManagerState {

/// bool: false queing
 Map<String, DownloadStatus> get ongoingDownloads;
/// Create a copy of DownloadManagerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DownloadManagerStateCopyWith<DownloadManagerState> get copyWith => _$DownloadManagerStateCopyWithImpl<DownloadManagerState>(this as DownloadManagerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadManagerState&&const DeepCollectionEquality().equals(other.ongoingDownloads, ongoingDownloads));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(ongoingDownloads));

@override
String toString() {
  return 'DownloadManagerState(ongoingDownloads: $ongoingDownloads)';
}


}

/// @nodoc
abstract mixin class $DownloadManagerStateCopyWith<$Res>  {
  factory $DownloadManagerStateCopyWith(DownloadManagerState value, $Res Function(DownloadManagerState) _then) = _$DownloadManagerStateCopyWithImpl;
@useResult
$Res call({
 Map<String, DownloadStatus> ongoingDownloads
});




}
/// @nodoc
class _$DownloadManagerStateCopyWithImpl<$Res>
    implements $DownloadManagerStateCopyWith<$Res> {
  _$DownloadManagerStateCopyWithImpl(this._self, this._then);

  final DownloadManagerState _self;
  final $Res Function(DownloadManagerState) _then;

/// Create a copy of DownloadManagerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ongoingDownloads = null,}) {
  return _then(_self.copyWith(
ongoingDownloads: null == ongoingDownloads ? _self.ongoingDownloads : ongoingDownloads // ignore: cast_nullable_to_non_nullable
as Map<String, DownloadStatus>,
  ));
}

}


/// Adds pattern-matching-related methods to [DownloadManagerState].
extension DownloadManagerStatePatterns on DownloadManagerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DownloadManagerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DownloadManagerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DownloadManagerState value)  $default,){
final _that = this;
switch (_that) {
case _DownloadManagerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DownloadManagerState value)?  $default,){
final _that = this;
switch (_that) {
case _DownloadManagerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, DownloadStatus> ongoingDownloads)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DownloadManagerState() when $default != null:
return $default(_that.ongoingDownloads);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, DownloadStatus> ongoingDownloads)  $default,) {final _that = this;
switch (_that) {
case _DownloadManagerState():
return $default(_that.ongoingDownloads);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, DownloadStatus> ongoingDownloads)?  $default,) {final _that = this;
switch (_that) {
case _DownloadManagerState() when $default != null:
return $default(_that.ongoingDownloads);case _:
  return null;

}
}

}

/// @nodoc


class _DownloadManagerState implements DownloadManagerState {
  const _DownloadManagerState({final  Map<String, DownloadStatus> ongoingDownloads = const {}}): _ongoingDownloads = ongoingDownloads;
  

/// bool: false queing
 final  Map<String, DownloadStatus> _ongoingDownloads;
/// bool: false queing
@override@JsonKey() Map<String, DownloadStatus> get ongoingDownloads {
  if (_ongoingDownloads is EqualUnmodifiableMapView) return _ongoingDownloads;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_ongoingDownloads);
}


/// Create a copy of DownloadManagerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DownloadManagerStateCopyWith<_DownloadManagerState> get copyWith => __$DownloadManagerStateCopyWithImpl<_DownloadManagerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DownloadManagerState&&const DeepCollectionEquality().equals(other._ongoingDownloads, _ongoingDownloads));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_ongoingDownloads));

@override
String toString() {
  return 'DownloadManagerState(ongoingDownloads: $ongoingDownloads)';
}


}

/// @nodoc
abstract mixin class _$DownloadManagerStateCopyWith<$Res> implements $DownloadManagerStateCopyWith<$Res> {
  factory _$DownloadManagerStateCopyWith(_DownloadManagerState value, $Res Function(_DownloadManagerState) _then) = __$DownloadManagerStateCopyWithImpl;
@override @useResult
$Res call({
 Map<String, DownloadStatus> ongoingDownloads
});




}
/// @nodoc
class __$DownloadManagerStateCopyWithImpl<$Res>
    implements _$DownloadManagerStateCopyWith<$Res> {
  __$DownloadManagerStateCopyWithImpl(this._self, this._then);

  final _DownloadManagerState _self;
  final $Res Function(_DownloadManagerState) _then;

/// Create a copy of DownloadManagerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ongoingDownloads = null,}) {
  return _then(_DownloadManagerState(
ongoingDownloads: null == ongoingDownloads ? _self._ongoingDownloads : ongoingDownloads // ignore: cast_nullable_to_non_nullable
as Map<String, DownloadStatus>,
  ));
}


}

// dart format on
