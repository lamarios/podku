// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendations.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecommendationsState {

 bool get loading; List<SearchResult> get recommendations;
/// Create a copy of RecommendationsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecommendationsStateCopyWith<RecommendationsState> get copyWith => _$RecommendationsStateCopyWithImpl<RecommendationsState>(this as RecommendationsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RecommendationsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecommendationsState&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&const DeepCollectionEquality().equals(other.recommendations, _this.recommendations));
}


@override
int get hashCode {
  final _this = this as RecommendationsState;
  return Object.hash(runtimeType,_this.loading,const DeepCollectionEquality().hash(_this.recommendations));
}

@override
String toString() {
  final _this = this as RecommendationsState;
  return 'RecommendationsState(loading: ${_this.loading}, recommendations: ${_this.recommendations})';
}


}

/// @nodoc
abstract mixin class $RecommendationsStateCopyWith<$Res>  {
  factory $RecommendationsStateCopyWith(RecommendationsState value, $Res Function(RecommendationsState) _then) = _$RecommendationsStateCopyWithImpl;
@useResult
$Res call({
 bool loading, List<SearchResult> recommendations
});




}
/// @nodoc
class _$RecommendationsStateCopyWithImpl<$Res>
    implements $RecommendationsStateCopyWith<$Res> {
  _$RecommendationsStateCopyWithImpl(this._self, this._then);

  final RecommendationsState _self;
  final $Res Function(RecommendationsState) _then;

/// Create a copy of RecommendationsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? recommendations = null,}) {
  return _then(RecommendationsState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,recommendations: null == recommendations ? _self.recommendations : recommendations // ignore: cast_nullable_to_non_nullable
as List<SearchResult>,
  ));
}

}


/// Adds pattern-matching-related methods to [RecommendationsState].
extension RecommendationsStatePatterns on RecommendationsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecommendationsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecommendationsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecommendationsState value)  $default,){
final _that = this;
switch (_that) {
case _RecommendationsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecommendationsState value)?  $default,){
final _that = this;
switch (_that) {
case _RecommendationsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  List<SearchResult> recommendations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecommendationsState() when $default != null:
return $default(_that.loading,_that.recommendations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  List<SearchResult> recommendations)  $default,) {final _that = this;
switch (_that) {
case _RecommendationsState():
return $default(_that.loading,_that.recommendations);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  List<SearchResult> recommendations)?  $default,) {final _that = this;
switch (_that) {
case _RecommendationsState() when $default != null:
return $default(_that.loading,_that.recommendations);case _:
  return null;

}
}

}

/// @nodoc


class _RecommendationsState implements RecommendationsState {
  const _RecommendationsState({this.loading = true,  List<SearchResult> recommendations = const []}): _recommendations = recommendations;
  

@override@JsonKey() final  bool loading;
 final  List<SearchResult> _recommendations;
@override@JsonKey() List<SearchResult> get recommendations {
  if (_recommendations is EqualUnmodifiableListView) return _recommendations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recommendations);
}


/// Create a copy of RecommendationsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecommendationsStateCopyWith<_RecommendationsState> get copyWith => __$RecommendationsStateCopyWithImpl<_RecommendationsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecommendationsState&&(identical(other.loading, loading) || other.loading == loading)&&const DeepCollectionEquality().equals(other.recommendations, _recommendations));
}


@override
int get hashCode {
    return Object.hash(runtimeType,loading,const DeepCollectionEquality().hash(_recommendations));
}

@override
String toString() {
    return 'RecommendationsState(loading: $loading, recommendations: $recommendations)';
}


}

/// @nodoc
abstract mixin class _$RecommendationsStateCopyWith<$Res> implements $RecommendationsStateCopyWith<$Res> {
  factory _$RecommendationsStateCopyWith(_RecommendationsState value, $Res Function(_RecommendationsState) _then) = __$RecommendationsStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, List<SearchResult> recommendations
});




}
/// @nodoc
class __$RecommendationsStateCopyWithImpl<$Res>
    implements _$RecommendationsStateCopyWith<$Res> {
  __$RecommendationsStateCopyWithImpl(this._self, this._then);

  final _RecommendationsState _self;
  final $Res Function(_RecommendationsState) _then;

/// Create a copy of RecommendationsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? recommendations = null,}) {
  return _then(_RecommendationsState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,recommendations: null == recommendations ? _self._recommendations : recommendations // ignore: cast_nullable_to_non_nullable
as List<SearchResult>,
  ));
}


}

// dart format on
