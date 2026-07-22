// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'podcast_image_color.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PodcastImageColorState {

 Color get scaffoldColor; ColorScheme get colorScheme; bool get initialized;
/// Create a copy of PodcastImageColorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PodcastImageColorStateCopyWith<PodcastImageColorState> get copyWith => _$PodcastImageColorStateCopyWithImpl<PodcastImageColorState>(this as PodcastImageColorState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PodcastImageColorState&&(identical(other.scaffoldColor, scaffoldColor) || other.scaffoldColor == scaffoldColor)&&(identical(other.colorScheme, colorScheme) || other.colorScheme == colorScheme)&&(identical(other.initialized, initialized) || other.initialized == initialized));
}


@override
int get hashCode => Object.hash(runtimeType,scaffoldColor,colorScheme,initialized);

@override
String toString() {
  return 'PodcastImageColorState(scaffoldColor: $scaffoldColor, colorScheme: $colorScheme, initialized: $initialized)';
}


}

/// @nodoc
abstract mixin class $PodcastImageColorStateCopyWith<$Res>  {
  factory $PodcastImageColorStateCopyWith(PodcastImageColorState value, $Res Function(PodcastImageColorState) _then) = _$PodcastImageColorStateCopyWithImpl;
@useResult
$Res call({
 Color scaffoldColor, ColorScheme colorScheme, bool initialized
});




}
/// @nodoc
class _$PodcastImageColorStateCopyWithImpl<$Res>
    implements $PodcastImageColorStateCopyWith<$Res> {
  _$PodcastImageColorStateCopyWithImpl(this._self, this._then);

  final PodcastImageColorState _self;
  final $Res Function(PodcastImageColorState) _then;

/// Create a copy of PodcastImageColorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scaffoldColor = null,Object? colorScheme = null,Object? initialized = null,}) {
  return _then(_self.copyWith(
scaffoldColor: null == scaffoldColor ? _self.scaffoldColor : scaffoldColor // ignore: cast_nullable_to_non_nullable
as Color,colorScheme: null == colorScheme ? _self.colorScheme : colorScheme // ignore: cast_nullable_to_non_nullable
as ColorScheme,initialized: null == initialized ? _self.initialized : initialized // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PodcastImageColorState].
extension PodcastImageColorStatePatterns on PodcastImageColorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PodcastImageColorState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PodcastImageColorState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PodcastImageColorState value)  $default,){
final _that = this;
switch (_that) {
case _PodcastImageColorState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PodcastImageColorState value)?  $default,){
final _that = this;
switch (_that) {
case _PodcastImageColorState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Color scaffoldColor,  ColorScheme colorScheme,  bool initialized)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PodcastImageColorState() when $default != null:
return $default(_that.scaffoldColor,_that.colorScheme,_that.initialized);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Color scaffoldColor,  ColorScheme colorScheme,  bool initialized)  $default,) {final _that = this;
switch (_that) {
case _PodcastImageColorState():
return $default(_that.scaffoldColor,_that.colorScheme,_that.initialized);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Color scaffoldColor,  ColorScheme colorScheme,  bool initialized)?  $default,) {final _that = this;
switch (_that) {
case _PodcastImageColorState() when $default != null:
return $default(_that.scaffoldColor,_that.colorScheme,_that.initialized);case _:
  return null;

}
}

}

/// @nodoc


class _PodcastImageColorState implements PodcastImageColorState {
  const _PodcastImageColorState({required this.scaffoldColor, required this.colorScheme, this.initialized = false});
  

@override final  Color scaffoldColor;
@override final  ColorScheme colorScheme;
@override@JsonKey() final  bool initialized;

/// Create a copy of PodcastImageColorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PodcastImageColorStateCopyWith<_PodcastImageColorState> get copyWith => __$PodcastImageColorStateCopyWithImpl<_PodcastImageColorState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PodcastImageColorState&&(identical(other.scaffoldColor, scaffoldColor) || other.scaffoldColor == scaffoldColor)&&(identical(other.colorScheme, colorScheme) || other.colorScheme == colorScheme)&&(identical(other.initialized, initialized) || other.initialized == initialized));
}


@override
int get hashCode => Object.hash(runtimeType,scaffoldColor,colorScheme,initialized);

@override
String toString() {
  return 'PodcastImageColorState(scaffoldColor: $scaffoldColor, colorScheme: $colorScheme, initialized: $initialized)';
}


}

/// @nodoc
abstract mixin class _$PodcastImageColorStateCopyWith<$Res> implements $PodcastImageColorStateCopyWith<$Res> {
  factory _$PodcastImageColorStateCopyWith(_PodcastImageColorState value, $Res Function(_PodcastImageColorState) _then) = __$PodcastImageColorStateCopyWithImpl;
@override @useResult
$Res call({
 Color scaffoldColor, ColorScheme colorScheme, bool initialized
});




}
/// @nodoc
class __$PodcastImageColorStateCopyWithImpl<$Res>
    implements _$PodcastImageColorStateCopyWith<$Res> {
  __$PodcastImageColorStateCopyWithImpl(this._self, this._then);

  final _PodcastImageColorState _self;
  final $Res Function(_PodcastImageColorState) _then;

/// Create a copy of PodcastImageColorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scaffoldColor = null,Object? colorScheme = null,Object? initialized = null,}) {
  return _then(_PodcastImageColorState(
scaffoldColor: null == scaffoldColor ? _self.scaffoldColor : scaffoldColor // ignore: cast_nullable_to_non_nullable
as Color,colorScheme: null == colorScheme ? _self.colorScheme : colorScheme // ignore: cast_nullable_to_non_nullable
as ColorScheme,initialized: null == initialized ? _self.initialized : initialized // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
