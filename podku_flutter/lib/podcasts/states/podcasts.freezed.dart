// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'podcasts.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PodcastState {

 List<Podcast> get subscriptions;
/// Create a copy of PodcastState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PodcastStateCopyWith<PodcastState> get copyWith => _$PodcastStateCopyWithImpl<PodcastState>(this as PodcastState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PodcastState&&const DeepCollectionEquality().equals(other.subscriptions, subscriptions));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(subscriptions));

@override
String toString() {
  return 'PodcastState(subscriptions: $subscriptions)';
}


}

/// @nodoc
abstract mixin class $PodcastStateCopyWith<$Res>  {
  factory $PodcastStateCopyWith(PodcastState value, $Res Function(PodcastState) _then) = _$PodcastStateCopyWithImpl;
@useResult
$Res call({
 List<Podcast> subscriptions
});




}
/// @nodoc
class _$PodcastStateCopyWithImpl<$Res>
    implements $PodcastStateCopyWith<$Res> {
  _$PodcastStateCopyWithImpl(this._self, this._then);

  final PodcastState _self;
  final $Res Function(PodcastState) _then;

/// Create a copy of PodcastState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subscriptions = null,}) {
  return _then(_self.copyWith(
subscriptions: null == subscriptions ? _self.subscriptions : subscriptions // ignore: cast_nullable_to_non_nullable
as List<Podcast>,
  ));
}

}


/// Adds pattern-matching-related methods to [PodcastState].
extension PodcastStatePatterns on PodcastState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PodcastState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PodcastState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PodcastState value)  $default,){
final _that = this;
switch (_that) {
case _PodcastState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PodcastState value)?  $default,){
final _that = this;
switch (_that) {
case _PodcastState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Podcast> subscriptions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PodcastState() when $default != null:
return $default(_that.subscriptions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Podcast> subscriptions)  $default,) {final _that = this;
switch (_that) {
case _PodcastState():
return $default(_that.subscriptions);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Podcast> subscriptions)?  $default,) {final _that = this;
switch (_that) {
case _PodcastState() when $default != null:
return $default(_that.subscriptions);case _:
  return null;

}
}

}

/// @nodoc


class _PodcastState implements PodcastState {
  const _PodcastState({final  List<Podcast> subscriptions = const []}): _subscriptions = subscriptions;
  

 final  List<Podcast> _subscriptions;
@override@JsonKey() List<Podcast> get subscriptions {
  if (_subscriptions is EqualUnmodifiableListView) return _subscriptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subscriptions);
}


/// Create a copy of PodcastState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PodcastStateCopyWith<_PodcastState> get copyWith => __$PodcastStateCopyWithImpl<_PodcastState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PodcastState&&const DeepCollectionEquality().equals(other._subscriptions, _subscriptions));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_subscriptions));

@override
String toString() {
  return 'PodcastState(subscriptions: $subscriptions)';
}


}

/// @nodoc
abstract mixin class _$PodcastStateCopyWith<$Res> implements $PodcastStateCopyWith<$Res> {
  factory _$PodcastStateCopyWith(_PodcastState value, $Res Function(_PodcastState) _then) = __$PodcastStateCopyWithImpl;
@override @useResult
$Res call({
 List<Podcast> subscriptions
});




}
/// @nodoc
class __$PodcastStateCopyWithImpl<$Res>
    implements _$PodcastStateCopyWith<$Res> {
  __$PodcastStateCopyWithImpl(this._self, this._then);

  final _PodcastState _self;
  final $Res Function(_PodcastState) _then;

/// Create a copy of PodcastState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subscriptions = null,}) {
  return _then(_PodcastState(
subscriptions: null == subscriptions ? _self._subscriptions : subscriptions // ignore: cast_nullable_to_non_nullable
as List<Podcast>,
  ));
}


}

// dart format on
