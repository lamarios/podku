// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bookmarks.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookmarksState {

 List<BookmarkWithTranscript> get bookmarks; bool get loading; dynamic get error; StackTrace? get stackTrace;
/// Create a copy of BookmarksState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookmarksStateCopyWith<BookmarksState> get copyWith => _$BookmarksStateCopyWithImpl<BookmarksState>(this as BookmarksState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookmarksState&&const DeepCollectionEquality().equals(other.bookmarks, bookmarks)&&(identical(other.loading, loading) || other.loading == loading)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(bookmarks),loading,const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'BookmarksState(bookmarks: $bookmarks, loading: $loading, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $BookmarksStateCopyWith<$Res>  {
  factory $BookmarksStateCopyWith(BookmarksState value, $Res Function(BookmarksState) _then) = _$BookmarksStateCopyWithImpl;
@useResult
$Res call({
 List<BookmarkWithTranscript> bookmarks, bool loading, dynamic error, StackTrace? stackTrace
});




}
/// @nodoc
class _$BookmarksStateCopyWithImpl<$Res>
    implements $BookmarksStateCopyWith<$Res> {
  _$BookmarksStateCopyWithImpl(this._self, this._then);

  final BookmarksState _self;
  final $Res Function(BookmarksState) _then;

/// Create a copy of BookmarksState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bookmarks = null,Object? loading = null,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(_self.copyWith(
bookmarks: null == bookmarks ? _self.bookmarks : bookmarks // ignore: cast_nullable_to_non_nullable
as List<BookmarkWithTranscript>,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookmarksState].
extension BookmarksStatePatterns on BookmarksState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookmarksState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookmarksState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookmarksState value)  $default,){
final _that = this;
switch (_that) {
case _BookmarksState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookmarksState value)?  $default,){
final _that = this;
switch (_that) {
case _BookmarksState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BookmarkWithTranscript> bookmarks,  bool loading,  dynamic error,  StackTrace? stackTrace)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookmarksState() when $default != null:
return $default(_that.bookmarks,_that.loading,_that.error,_that.stackTrace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BookmarkWithTranscript> bookmarks,  bool loading,  dynamic error,  StackTrace? stackTrace)  $default,) {final _that = this;
switch (_that) {
case _BookmarksState():
return $default(_that.bookmarks,_that.loading,_that.error,_that.stackTrace);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BookmarkWithTranscript> bookmarks,  bool loading,  dynamic error,  StackTrace? stackTrace)?  $default,) {final _that = this;
switch (_that) {
case _BookmarksState() when $default != null:
return $default(_that.bookmarks,_that.loading,_that.error,_that.stackTrace);case _:
  return null;

}
}

}

/// @nodoc


class _BookmarksState implements BookmarksState, WithError {
  const _BookmarksState({final  List<BookmarkWithTranscript> bookmarks = const [], this.loading = true, this.error, this.stackTrace}): _bookmarks = bookmarks;
  

 final  List<BookmarkWithTranscript> _bookmarks;
@override@JsonKey() List<BookmarkWithTranscript> get bookmarks {
  if (_bookmarks is EqualUnmodifiableListView) return _bookmarks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bookmarks);
}

@override@JsonKey() final  bool loading;
@override final  dynamic error;
@override final  StackTrace? stackTrace;

/// Create a copy of BookmarksState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookmarksStateCopyWith<_BookmarksState> get copyWith => __$BookmarksStateCopyWithImpl<_BookmarksState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookmarksState&&const DeepCollectionEquality().equals(other._bookmarks, _bookmarks)&&(identical(other.loading, loading) || other.loading == loading)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_bookmarks),loading,const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'BookmarksState(bookmarks: $bookmarks, loading: $loading, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class _$BookmarksStateCopyWith<$Res> implements $BookmarksStateCopyWith<$Res> {
  factory _$BookmarksStateCopyWith(_BookmarksState value, $Res Function(_BookmarksState) _then) = __$BookmarksStateCopyWithImpl;
@override @useResult
$Res call({
 List<BookmarkWithTranscript> bookmarks, bool loading, dynamic error, StackTrace? stackTrace
});




}
/// @nodoc
class __$BookmarksStateCopyWithImpl<$Res>
    implements _$BookmarksStateCopyWith<$Res> {
  __$BookmarksStateCopyWithImpl(this._self, this._then);

  final _BookmarksState _self;
  final $Res Function(_BookmarksState) _then;

/// Create a copy of BookmarksState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bookmarks = null,Object? loading = null,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(_BookmarksState(
bookmarks: null == bookmarks ? _self._bookmarks : bookmarks // ignore: cast_nullable_to_non_nullable
as List<BookmarkWithTranscript>,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

// dart format on
