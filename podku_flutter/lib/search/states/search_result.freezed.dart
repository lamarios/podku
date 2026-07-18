// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchResultState {

 bool get loading; bool get subscribed; bool get subscribing; Podcast? get podcast;
/// Create a copy of SearchResultState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchResultStateCopyWith<SearchResultState> get copyWith => _$SearchResultStateCopyWithImpl<SearchResultState>(this as SearchResultState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchResultState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.subscribed, subscribed) || other.subscribed == subscribed)&&(identical(other.subscribing, subscribing) || other.subscribing == subscribing)&&(identical(other.podcast, podcast) || other.podcast == podcast));
}


@override
int get hashCode => Object.hash(runtimeType,loading,subscribed,subscribing,podcast);

@override
String toString() {
  return 'SearchResultState(loading: $loading, subscribed: $subscribed, subscribing: $subscribing, podcast: $podcast)';
}


}

/// @nodoc
abstract mixin class $SearchResultStateCopyWith<$Res>  {
  factory $SearchResultStateCopyWith(SearchResultState value, $Res Function(SearchResultState) _then) = _$SearchResultStateCopyWithImpl;
@useResult
$Res call({
 bool loading, bool subscribed, bool subscribing, Podcast? podcast
});




}
/// @nodoc
class _$SearchResultStateCopyWithImpl<$Res>
    implements $SearchResultStateCopyWith<$Res> {
  _$SearchResultStateCopyWithImpl(this._self, this._then);

  final SearchResultState _self;
  final $Res Function(SearchResultState) _then;

/// Create a copy of SearchResultState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? subscribed = null,Object? subscribing = null,Object? podcast = freezed,}) {
  return _then(_self.copyWith(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,subscribed: null == subscribed ? _self.subscribed : subscribed // ignore: cast_nullable_to_non_nullable
as bool,subscribing: null == subscribing ? _self.subscribing : subscribing // ignore: cast_nullable_to_non_nullable
as bool,podcast: freezed == podcast ? _self.podcast : podcast // ignore: cast_nullable_to_non_nullable
as Podcast?,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchResultState].
extension SearchResultStatePatterns on SearchResultState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchResultState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchResultState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchResultState value)  $default,){
final _that = this;
switch (_that) {
case _SearchResultState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchResultState value)?  $default,){
final _that = this;
switch (_that) {
case _SearchResultState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  bool subscribed,  bool subscribing,  Podcast? podcast)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchResultState() when $default != null:
return $default(_that.loading,_that.subscribed,_that.subscribing,_that.podcast);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  bool subscribed,  bool subscribing,  Podcast? podcast)  $default,) {final _that = this;
switch (_that) {
case _SearchResultState():
return $default(_that.loading,_that.subscribed,_that.subscribing,_that.podcast);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  bool subscribed,  bool subscribing,  Podcast? podcast)?  $default,) {final _that = this;
switch (_that) {
case _SearchResultState() when $default != null:
return $default(_that.loading,_that.subscribed,_that.subscribing,_that.podcast);case _:
  return null;

}
}

}

/// @nodoc


class _SearchResultState implements SearchResultState {
  const _SearchResultState({this.loading = true, this.subscribed = false, this.subscribing = false, this.podcast});
  

@override@JsonKey() final  bool loading;
@override@JsonKey() final  bool subscribed;
@override@JsonKey() final  bool subscribing;
@override final  Podcast? podcast;

/// Create a copy of SearchResultState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchResultStateCopyWith<_SearchResultState> get copyWith => __$SearchResultStateCopyWithImpl<_SearchResultState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchResultState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.subscribed, subscribed) || other.subscribed == subscribed)&&(identical(other.subscribing, subscribing) || other.subscribing == subscribing)&&(identical(other.podcast, podcast) || other.podcast == podcast));
}


@override
int get hashCode => Object.hash(runtimeType,loading,subscribed,subscribing,podcast);

@override
String toString() {
  return 'SearchResultState(loading: $loading, subscribed: $subscribed, subscribing: $subscribing, podcast: $podcast)';
}


}

/// @nodoc
abstract mixin class _$SearchResultStateCopyWith<$Res> implements $SearchResultStateCopyWith<$Res> {
  factory _$SearchResultStateCopyWith(_SearchResultState value, $Res Function(_SearchResultState) _then) = __$SearchResultStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, bool subscribed, bool subscribing, Podcast? podcast
});




}
/// @nodoc
class __$SearchResultStateCopyWithImpl<$Res>
    implements _$SearchResultStateCopyWith<$Res> {
  __$SearchResultStateCopyWithImpl(this._self, this._then);

  final _SearchResultState _self;
  final $Res Function(_SearchResultState) _then;

/// Create a copy of SearchResultState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? subscribed = null,Object? subscribing = null,Object? podcast = freezed,}) {
  return _then(_SearchResultState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,subscribed: null == subscribed ? _self.subscribed : subscribed // ignore: cast_nullable_to_non_nullable
as bool,subscribing: null == subscribing ? _self.subscribing : subscribing // ignore: cast_nullable_to_non_nullable
as bool,podcast: freezed == podcast ? _self.podcast : podcast // ignore: cast_nullable_to_non_nullable
as Podcast?,
  ));
}


}

// dart format on
