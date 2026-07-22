// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'podcast.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PodcastState {

 Podcast? get podcast; bool get loading; bool get subscribing; dynamic get error; StackTrace? get stackTrace;
/// Create a copy of PodcastState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PodcastStateCopyWith<PodcastState> get copyWith => _$PodcastStateCopyWithImpl<PodcastState>(this as PodcastState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PodcastState&&(identical(other.podcast, podcast) || other.podcast == podcast)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.subscribing, subscribing) || other.subscribing == subscribing)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,podcast,loading,subscribing,const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'PodcastState(podcast: $podcast, loading: $loading, subscribing: $subscribing, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $PodcastStateCopyWith<$Res>  {
  factory $PodcastStateCopyWith(PodcastState value, $Res Function(PodcastState) _then) = _$PodcastStateCopyWithImpl;
@useResult
$Res call({
 Podcast? podcast, bool loading, bool subscribing, dynamic error, StackTrace? stackTrace
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
@pragma('vm:prefer-inline') @override $Res call({Object? podcast = freezed,Object? loading = null,Object? subscribing = null,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(_self.copyWith(
podcast: freezed == podcast ? _self.podcast : podcast // ignore: cast_nullable_to_non_nullable
as Podcast?,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,subscribing: null == subscribing ? _self.subscribing : subscribing // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Podcast? podcast,  bool loading,  bool subscribing,  dynamic error,  StackTrace? stackTrace)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PodcastState() when $default != null:
return $default(_that.podcast,_that.loading,_that.subscribing,_that.error,_that.stackTrace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Podcast? podcast,  bool loading,  bool subscribing,  dynamic error,  StackTrace? stackTrace)  $default,) {final _that = this;
switch (_that) {
case _PodcastState():
return $default(_that.podcast,_that.loading,_that.subscribing,_that.error,_that.stackTrace);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Podcast? podcast,  bool loading,  bool subscribing,  dynamic error,  StackTrace? stackTrace)?  $default,) {final _that = this;
switch (_that) {
case _PodcastState() when $default != null:
return $default(_that.podcast,_that.loading,_that.subscribing,_that.error,_that.stackTrace);case _:
  return null;

}
}

}

/// @nodoc


class _PodcastState extends PodcastState implements WithError {
  const _PodcastState({this.podcast, this.loading = true, this.subscribing = false, this.error, this.stackTrace}): super._();
  

@override final  Podcast? podcast;
@override@JsonKey() final  bool loading;
@override@JsonKey() final  bool subscribing;
@override final  dynamic error;
@override final  StackTrace? stackTrace;

/// Create a copy of PodcastState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PodcastStateCopyWith<_PodcastState> get copyWith => __$PodcastStateCopyWithImpl<_PodcastState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PodcastState&&(identical(other.podcast, podcast) || other.podcast == podcast)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.subscribing, subscribing) || other.subscribing == subscribing)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,podcast,loading,subscribing,const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'PodcastState(podcast: $podcast, loading: $loading, subscribing: $subscribing, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class _$PodcastStateCopyWith<$Res> implements $PodcastStateCopyWith<$Res> {
  factory _$PodcastStateCopyWith(_PodcastState value, $Res Function(_PodcastState) _then) = __$PodcastStateCopyWithImpl;
@override @useResult
$Res call({
 Podcast? podcast, bool loading, bool subscribing, dynamic error, StackTrace? stackTrace
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
@override @pragma('vm:prefer-inline') $Res call({Object? podcast = freezed,Object? loading = null,Object? subscribing = null,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(_PodcastState(
podcast: freezed == podcast ? _self.podcast : podcast // ignore: cast_nullable_to_non_nullable
as Podcast?,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,subscribing: null == subscribing ? _self.subscribing : subscribing // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

// dart format on
