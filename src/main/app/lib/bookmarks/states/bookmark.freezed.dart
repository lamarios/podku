// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bookmark.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookmarkState {

 BookmarkWithTranscript? get bookmark; bool get loading; String? get selectedLanguage; int get timeIndex; dynamic get error; StackTrace? get stackTrace;
/// Create a copy of BookmarkState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookmarkStateCopyWith<BookmarkState> get copyWith => _$BookmarkStateCopyWithImpl<BookmarkState>(this as BookmarkState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookmarkState&&(identical(other.bookmark, bookmark) || other.bookmark == bookmark)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.selectedLanguage, selectedLanguage) || other.selectedLanguage == selectedLanguage)&&(identical(other.timeIndex, timeIndex) || other.timeIndex == timeIndex)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,bookmark,loading,selectedLanguage,timeIndex,const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'BookmarkState(bookmark: $bookmark, loading: $loading, selectedLanguage: $selectedLanguage, timeIndex: $timeIndex, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $BookmarkStateCopyWith<$Res>  {
  factory $BookmarkStateCopyWith(BookmarkState value, $Res Function(BookmarkState) _then) = _$BookmarkStateCopyWithImpl;
@useResult
$Res call({
 BookmarkWithTranscript? bookmark, bool loading, String? selectedLanguage, int timeIndex, dynamic error, StackTrace? stackTrace
});




}
/// @nodoc
class _$BookmarkStateCopyWithImpl<$Res>
    implements $BookmarkStateCopyWith<$Res> {
  _$BookmarkStateCopyWithImpl(this._self, this._then);

  final BookmarkState _self;
  final $Res Function(BookmarkState) _then;

/// Create a copy of BookmarkState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bookmark = freezed,Object? loading = null,Object? selectedLanguage = freezed,Object? timeIndex = null,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(_self.copyWith(
bookmark: freezed == bookmark ? _self.bookmark : bookmark // ignore: cast_nullable_to_non_nullable
as BookmarkWithTranscript?,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,selectedLanguage: freezed == selectedLanguage ? _self.selectedLanguage : selectedLanguage // ignore: cast_nullable_to_non_nullable
as String?,timeIndex: null == timeIndex ? _self.timeIndex : timeIndex // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookmarkState].
extension BookmarkStatePatterns on BookmarkState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookmarkState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookmarkState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookmarkState value)  $default,){
final _that = this;
switch (_that) {
case _BookmarkState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookmarkState value)?  $default,){
final _that = this;
switch (_that) {
case _BookmarkState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BookmarkWithTranscript? bookmark,  bool loading,  String? selectedLanguage,  int timeIndex,  dynamic error,  StackTrace? stackTrace)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookmarkState() when $default != null:
return $default(_that.bookmark,_that.loading,_that.selectedLanguage,_that.timeIndex,_that.error,_that.stackTrace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BookmarkWithTranscript? bookmark,  bool loading,  String? selectedLanguage,  int timeIndex,  dynamic error,  StackTrace? stackTrace)  $default,) {final _that = this;
switch (_that) {
case _BookmarkState():
return $default(_that.bookmark,_that.loading,_that.selectedLanguage,_that.timeIndex,_that.error,_that.stackTrace);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BookmarkWithTranscript? bookmark,  bool loading,  String? selectedLanguage,  int timeIndex,  dynamic error,  StackTrace? stackTrace)?  $default,) {final _that = this;
switch (_that) {
case _BookmarkState() when $default != null:
return $default(_that.bookmark,_that.loading,_that.selectedLanguage,_that.timeIndex,_that.error,_that.stackTrace);case _:
  return null;

}
}

}

/// @nodoc


class _BookmarkState implements BookmarkState, WithError {
  const _BookmarkState({this.bookmark, this.loading = true, this.selectedLanguage, this.timeIndex = -1, this.error, this.stackTrace});
  

@override final  BookmarkWithTranscript? bookmark;
@override@JsonKey() final  bool loading;
@override final  String? selectedLanguage;
@override@JsonKey() final  int timeIndex;
@override final  dynamic error;
@override final  StackTrace? stackTrace;

/// Create a copy of BookmarkState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookmarkStateCopyWith<_BookmarkState> get copyWith => __$BookmarkStateCopyWithImpl<_BookmarkState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookmarkState&&(identical(other.bookmark, bookmark) || other.bookmark == bookmark)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.selectedLanguage, selectedLanguage) || other.selectedLanguage == selectedLanguage)&&(identical(other.timeIndex, timeIndex) || other.timeIndex == timeIndex)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,bookmark,loading,selectedLanguage,timeIndex,const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'BookmarkState(bookmark: $bookmark, loading: $loading, selectedLanguage: $selectedLanguage, timeIndex: $timeIndex, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class _$BookmarkStateCopyWith<$Res> implements $BookmarkStateCopyWith<$Res> {
  factory _$BookmarkStateCopyWith(_BookmarkState value, $Res Function(_BookmarkState) _then) = __$BookmarkStateCopyWithImpl;
@override @useResult
$Res call({
 BookmarkWithTranscript? bookmark, bool loading, String? selectedLanguage, int timeIndex, dynamic error, StackTrace? stackTrace
});




}
/// @nodoc
class __$BookmarkStateCopyWithImpl<$Res>
    implements _$BookmarkStateCopyWith<$Res> {
  __$BookmarkStateCopyWithImpl(this._self, this._then);

  final _BookmarkState _self;
  final $Res Function(_BookmarkState) _then;

/// Create a copy of BookmarkState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bookmark = freezed,Object? loading = null,Object? selectedLanguage = freezed,Object? timeIndex = null,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(_BookmarkState(
bookmark: freezed == bookmark ? _self.bookmark : bookmark // ignore: cast_nullable_to_non_nullable
as BookmarkWithTranscript?,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,selectedLanguage: freezed == selectedLanguage ? _self.selectedLanguage : selectedLanguage // ignore: cast_nullable_to_non_nullable
as String?,timeIndex: null == timeIndex ? _self.timeIndex : timeIndex // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

// dart format on
