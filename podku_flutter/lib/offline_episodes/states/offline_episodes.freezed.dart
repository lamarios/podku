// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offline_episodes.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OfflineEpisodesState {

 List<Episode> get offlineEpisodes;
/// Create a copy of OfflineEpisodesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfflineEpisodesStateCopyWith<OfflineEpisodesState> get copyWith => _$OfflineEpisodesStateCopyWithImpl<OfflineEpisodesState>(this as OfflineEpisodesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfflineEpisodesState&&const DeepCollectionEquality().equals(other.offlineEpisodes, offlineEpisodes));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(offlineEpisodes));

@override
String toString() {
  return 'OfflineEpisodesState(offlineEpisodes: $offlineEpisodes)';
}


}

/// @nodoc
abstract mixin class $OfflineEpisodesStateCopyWith<$Res>  {
  factory $OfflineEpisodesStateCopyWith(OfflineEpisodesState value, $Res Function(OfflineEpisodesState) _then) = _$OfflineEpisodesStateCopyWithImpl;
@useResult
$Res call({
 List<Episode> offlineEpisodes
});




}
/// @nodoc
class _$OfflineEpisodesStateCopyWithImpl<$Res>
    implements $OfflineEpisodesStateCopyWith<$Res> {
  _$OfflineEpisodesStateCopyWithImpl(this._self, this._then);

  final OfflineEpisodesState _self;
  final $Res Function(OfflineEpisodesState) _then;

/// Create a copy of OfflineEpisodesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? offlineEpisodes = null,}) {
  return _then(_self.copyWith(
offlineEpisodes: null == offlineEpisodes ? _self.offlineEpisodes : offlineEpisodes // ignore: cast_nullable_to_non_nullable
as List<Episode>,
  ));
}

}


/// Adds pattern-matching-related methods to [OfflineEpisodesState].
extension OfflineEpisodesStatePatterns on OfflineEpisodesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OfflineEpisodesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OfflineEpisodesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OfflineEpisodesState value)  $default,){
final _that = this;
switch (_that) {
case _OfflineEpisodesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OfflineEpisodesState value)?  $default,){
final _that = this;
switch (_that) {
case _OfflineEpisodesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Episode> offlineEpisodes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OfflineEpisodesState() when $default != null:
return $default(_that.offlineEpisodes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Episode> offlineEpisodes)  $default,) {final _that = this;
switch (_that) {
case _OfflineEpisodesState():
return $default(_that.offlineEpisodes);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Episode> offlineEpisodes)?  $default,) {final _that = this;
switch (_that) {
case _OfflineEpisodesState() when $default != null:
return $default(_that.offlineEpisodes);case _:
  return null;

}
}

}

/// @nodoc


class _OfflineEpisodesState implements OfflineEpisodesState {
  const _OfflineEpisodesState({final  List<Episode> offlineEpisodes = const []}): _offlineEpisodes = offlineEpisodes;
  

 final  List<Episode> _offlineEpisodes;
@override@JsonKey() List<Episode> get offlineEpisodes {
  if (_offlineEpisodes is EqualUnmodifiableListView) return _offlineEpisodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_offlineEpisodes);
}


/// Create a copy of OfflineEpisodesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfflineEpisodesStateCopyWith<_OfflineEpisodesState> get copyWith => __$OfflineEpisodesStateCopyWithImpl<_OfflineEpisodesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OfflineEpisodesState&&const DeepCollectionEquality().equals(other._offlineEpisodes, _offlineEpisodes));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_offlineEpisodes));

@override
String toString() {
  return 'OfflineEpisodesState(offlineEpisodes: $offlineEpisodes)';
}


}

/// @nodoc
abstract mixin class _$OfflineEpisodesStateCopyWith<$Res> implements $OfflineEpisodesStateCopyWith<$Res> {
  factory _$OfflineEpisodesStateCopyWith(_OfflineEpisodesState value, $Res Function(_OfflineEpisodesState) _then) = __$OfflineEpisodesStateCopyWithImpl;
@override @useResult
$Res call({
 List<Episode> offlineEpisodes
});




}
/// @nodoc
class __$OfflineEpisodesStateCopyWithImpl<$Res>
    implements _$OfflineEpisodesStateCopyWith<$Res> {
  __$OfflineEpisodesStateCopyWithImpl(this._self, this._then);

  final _OfflineEpisodesState _self;
  final $Res Function(_OfflineEpisodesState) _then;

/// Create a copy of OfflineEpisodesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? offlineEpisodes = null,}) {
  return _then(_OfflineEpisodesState(
offlineEpisodes: null == offlineEpisodes ? _self._offlineEpisodes : offlineEpisodes // ignore: cast_nullable_to_non_nullable
as List<Episode>,
  ));
}


}

// dart format on
