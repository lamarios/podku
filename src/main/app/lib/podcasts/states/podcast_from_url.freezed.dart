// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'podcast_from_url.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PodcastFromUrlState {

 bool get loading; Podcast? get podcast; int get page; bool get podcastError;
/// Create a copy of PodcastFromUrlState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PodcastFromUrlStateCopyWith<PodcastFromUrlState> get copyWith => _$PodcastFromUrlStateCopyWithImpl<PodcastFromUrlState>(this as PodcastFromUrlState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PodcastFromUrlState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.podcast, podcast) || other.podcast == podcast)&&(identical(other.page, page) || other.page == page)&&(identical(other.podcastError, podcastError) || other.podcastError == podcastError));
}


@override
int get hashCode => Object.hash(runtimeType,loading,podcast,page,podcastError);

@override
String toString() {
  return 'PodcastFromUrlState(loading: $loading, podcast: $podcast, page: $page, podcastError: $podcastError)';
}


}

/// @nodoc
abstract mixin class $PodcastFromUrlStateCopyWith<$Res>  {
  factory $PodcastFromUrlStateCopyWith(PodcastFromUrlState value, $Res Function(PodcastFromUrlState) _then) = _$PodcastFromUrlStateCopyWithImpl;
@useResult
$Res call({
 bool loading, Podcast? podcast, int page, bool podcastError
});




}
/// @nodoc
class _$PodcastFromUrlStateCopyWithImpl<$Res>
    implements $PodcastFromUrlStateCopyWith<$Res> {
  _$PodcastFromUrlStateCopyWithImpl(this._self, this._then);

  final PodcastFromUrlState _self;
  final $Res Function(PodcastFromUrlState) _then;

/// Create a copy of PodcastFromUrlState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? podcast = freezed,Object? page = null,Object? podcastError = null,}) {
  return _then(_self.copyWith(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,podcast: freezed == podcast ? _self.podcast : podcast // ignore: cast_nullable_to_non_nullable
as Podcast?,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,podcastError: null == podcastError ? _self.podcastError : podcastError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PodcastFromUrlState].
extension PodcastFromUrlStatePatterns on PodcastFromUrlState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PodcastFromUrlState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PodcastFromUrlState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PodcastFromUrlState value)  $default,){
final _that = this;
switch (_that) {
case _PodcastFromUrlState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PodcastFromUrlState value)?  $default,){
final _that = this;
switch (_that) {
case _PodcastFromUrlState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  Podcast? podcast,  int page,  bool podcastError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PodcastFromUrlState() when $default != null:
return $default(_that.loading,_that.podcast,_that.page,_that.podcastError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  Podcast? podcast,  int page,  bool podcastError)  $default,) {final _that = this;
switch (_that) {
case _PodcastFromUrlState():
return $default(_that.loading,_that.podcast,_that.page,_that.podcastError);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  Podcast? podcast,  int page,  bool podcastError)?  $default,) {final _that = this;
switch (_that) {
case _PodcastFromUrlState() when $default != null:
return $default(_that.loading,_that.podcast,_that.page,_that.podcastError);case _:
  return null;

}
}

}

/// @nodoc


class _PodcastFromUrlState implements PodcastFromUrlState {
  const _PodcastFromUrlState({this.loading = false, this.podcast, this.page = 0, this.podcastError = false});
  

@override@JsonKey() final  bool loading;
@override final  Podcast? podcast;
@override@JsonKey() final  int page;
@override@JsonKey() final  bool podcastError;

/// Create a copy of PodcastFromUrlState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PodcastFromUrlStateCopyWith<_PodcastFromUrlState> get copyWith => __$PodcastFromUrlStateCopyWithImpl<_PodcastFromUrlState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PodcastFromUrlState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.podcast, podcast) || other.podcast == podcast)&&(identical(other.page, page) || other.page == page)&&(identical(other.podcastError, podcastError) || other.podcastError == podcastError));
}


@override
int get hashCode => Object.hash(runtimeType,loading,podcast,page,podcastError);

@override
String toString() {
  return 'PodcastFromUrlState(loading: $loading, podcast: $podcast, page: $page, podcastError: $podcastError)';
}


}

/// @nodoc
abstract mixin class _$PodcastFromUrlStateCopyWith<$Res> implements $PodcastFromUrlStateCopyWith<$Res> {
  factory _$PodcastFromUrlStateCopyWith(_PodcastFromUrlState value, $Res Function(_PodcastFromUrlState) _then) = __$PodcastFromUrlStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, Podcast? podcast, int page, bool podcastError
});




}
/// @nodoc
class __$PodcastFromUrlStateCopyWithImpl<$Res>
    implements _$PodcastFromUrlStateCopyWith<$Res> {
  __$PodcastFromUrlStateCopyWithImpl(this._self, this._then);

  final _PodcastFromUrlState _self;
  final $Res Function(_PodcastFromUrlState) _then;

/// Create a copy of PodcastFromUrlState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? podcast = freezed,Object? page = null,Object? podcastError = null,}) {
  return _then(_PodcastFromUrlState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,podcast: freezed == podcast ? _self.podcast : podcast // ignore: cast_nullable_to_non_nullable
as Podcast?,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,podcastError: null == podcastError ? _self.podcastError : podcastError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
