// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transcript.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TranscriptState {

 bool get loading; int get index; String? get selectedLanguage; List<EpisodeTranscript> get transcript; List<String> get languages;
/// Create a copy of TranscriptState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TranscriptStateCopyWith<TranscriptState> get copyWith => _$TranscriptStateCopyWithImpl<TranscriptState>(this as TranscriptState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TranscriptState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.index, index) || other.index == index)&&(identical(other.selectedLanguage, selectedLanguage) || other.selectedLanguage == selectedLanguage)&&const DeepCollectionEquality().equals(other.transcript, transcript)&&const DeepCollectionEquality().equals(other.languages, languages));
}


@override
int get hashCode => Object.hash(runtimeType,loading,index,selectedLanguage,const DeepCollectionEquality().hash(transcript),const DeepCollectionEquality().hash(languages));

@override
String toString() {
  return 'TranscriptState(loading: $loading, index: $index, selectedLanguage: $selectedLanguage, transcript: $transcript, languages: $languages)';
}


}

/// @nodoc
abstract mixin class $TranscriptStateCopyWith<$Res>  {
  factory $TranscriptStateCopyWith(TranscriptState value, $Res Function(TranscriptState) _then) = _$TranscriptStateCopyWithImpl;
@useResult
$Res call({
 bool loading, int index, String? selectedLanguage, List<EpisodeTranscript> transcript, List<String> languages
});




}
/// @nodoc
class _$TranscriptStateCopyWithImpl<$Res>
    implements $TranscriptStateCopyWith<$Res> {
  _$TranscriptStateCopyWithImpl(this._self, this._then);

  final TranscriptState _self;
  final $Res Function(TranscriptState) _then;

/// Create a copy of TranscriptState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? index = null,Object? selectedLanguage = freezed,Object? transcript = null,Object? languages = null,}) {
  return _then(_self.copyWith(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,selectedLanguage: freezed == selectedLanguage ? _self.selectedLanguage : selectedLanguage // ignore: cast_nullable_to_non_nullable
as String?,transcript: null == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as List<EpisodeTranscript>,languages: null == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [TranscriptState].
extension TranscriptStatePatterns on TranscriptState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TranscriptState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TranscriptState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TranscriptState value)  $default,){
final _that = this;
switch (_that) {
case _TranscriptState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TranscriptState value)?  $default,){
final _that = this;
switch (_that) {
case _TranscriptState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  int index,  String? selectedLanguage,  List<EpisodeTranscript> transcript,  List<String> languages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TranscriptState() when $default != null:
return $default(_that.loading,_that.index,_that.selectedLanguage,_that.transcript,_that.languages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  int index,  String? selectedLanguage,  List<EpisodeTranscript> transcript,  List<String> languages)  $default,) {final _that = this;
switch (_that) {
case _TranscriptState():
return $default(_that.loading,_that.index,_that.selectedLanguage,_that.transcript,_that.languages);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  int index,  String? selectedLanguage,  List<EpisodeTranscript> transcript,  List<String> languages)?  $default,) {final _that = this;
switch (_that) {
case _TranscriptState() when $default != null:
return $default(_that.loading,_that.index,_that.selectedLanguage,_that.transcript,_that.languages);case _:
  return null;

}
}

}

/// @nodoc


class _TranscriptState implements TranscriptState {
  const _TranscriptState({this.loading = true, this.index = -1, this.selectedLanguage, final  List<EpisodeTranscript> transcript = const [], final  List<String> languages = const []}): _transcript = transcript,_languages = languages;
  

@override@JsonKey() final  bool loading;
@override@JsonKey() final  int index;
@override final  String? selectedLanguage;
 final  List<EpisodeTranscript> _transcript;
@override@JsonKey() List<EpisodeTranscript> get transcript {
  if (_transcript is EqualUnmodifiableListView) return _transcript;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transcript);
}

 final  List<String> _languages;
@override@JsonKey() List<String> get languages {
  if (_languages is EqualUnmodifiableListView) return _languages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_languages);
}


/// Create a copy of TranscriptState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TranscriptStateCopyWith<_TranscriptState> get copyWith => __$TranscriptStateCopyWithImpl<_TranscriptState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TranscriptState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.index, index) || other.index == index)&&(identical(other.selectedLanguage, selectedLanguage) || other.selectedLanguage == selectedLanguage)&&const DeepCollectionEquality().equals(other._transcript, _transcript)&&const DeepCollectionEquality().equals(other._languages, _languages));
}


@override
int get hashCode => Object.hash(runtimeType,loading,index,selectedLanguage,const DeepCollectionEquality().hash(_transcript),const DeepCollectionEquality().hash(_languages));

@override
String toString() {
  return 'TranscriptState(loading: $loading, index: $index, selectedLanguage: $selectedLanguage, transcript: $transcript, languages: $languages)';
}


}

/// @nodoc
abstract mixin class _$TranscriptStateCopyWith<$Res> implements $TranscriptStateCopyWith<$Res> {
  factory _$TranscriptStateCopyWith(_TranscriptState value, $Res Function(_TranscriptState) _then) = __$TranscriptStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, int index, String? selectedLanguage, List<EpisodeTranscript> transcript, List<String> languages
});




}
/// @nodoc
class __$TranscriptStateCopyWithImpl<$Res>
    implements _$TranscriptStateCopyWith<$Res> {
  __$TranscriptStateCopyWithImpl(this._self, this._then);

  final _TranscriptState _self;
  final $Res Function(_TranscriptState) _then;

/// Create a copy of TranscriptState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? index = null,Object? selectedLanguage = freezed,Object? transcript = null,Object? languages = null,}) {
  return _then(_TranscriptState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,selectedLanguage: freezed == selectedLanguage ? _self.selectedLanguage : selectedLanguage // ignore: cast_nullable_to_non_nullable
as String?,transcript: null == transcript ? _self._transcript : transcript // ignore: cast_nullable_to_non_nullable
as List<EpisodeTranscript>,languages: null == languages ? _self._languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
