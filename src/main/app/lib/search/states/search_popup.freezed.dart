// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_popup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchPopupState {

 bool get loadingDiscover; bool get loadingPodcasts; bool get loadingEpisodes; List<SearchResult> get discoverResults; List<PodcastLight> get podcastResults; List<Episode> get episodeResults;
/// Create a copy of SearchPopupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchPopupStateCopyWith<SearchPopupState> get copyWith => _$SearchPopupStateCopyWithImpl<SearchPopupState>(this as SearchPopupState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchPopupState&&(identical(other.loadingDiscover, loadingDiscover) || other.loadingDiscover == loadingDiscover)&&(identical(other.loadingPodcasts, loadingPodcasts) || other.loadingPodcasts == loadingPodcasts)&&(identical(other.loadingEpisodes, loadingEpisodes) || other.loadingEpisodes == loadingEpisodes)&&const DeepCollectionEquality().equals(other.discoverResults, discoverResults)&&const DeepCollectionEquality().equals(other.podcastResults, podcastResults)&&const DeepCollectionEquality().equals(other.episodeResults, episodeResults));
}


@override
int get hashCode => Object.hash(runtimeType,loadingDiscover,loadingPodcasts,loadingEpisodes,const DeepCollectionEquality().hash(discoverResults),const DeepCollectionEquality().hash(podcastResults),const DeepCollectionEquality().hash(episodeResults));

@override
String toString() {
  return 'SearchPopupState(loadingDiscover: $loadingDiscover, loadingPodcasts: $loadingPodcasts, loadingEpisodes: $loadingEpisodes, discoverResults: $discoverResults, podcastResults: $podcastResults, episodeResults: $episodeResults)';
}


}

/// @nodoc
abstract mixin class $SearchPopupStateCopyWith<$Res>  {
  factory $SearchPopupStateCopyWith(SearchPopupState value, $Res Function(SearchPopupState) _then) = _$SearchPopupStateCopyWithImpl;
@useResult
$Res call({
 bool loadingDiscover, bool loadingPodcasts, bool loadingEpisodes, List<SearchResult> discoverResults, List<PodcastLight> podcastResults, List<Episode> episodeResults
});




}
/// @nodoc
class _$SearchPopupStateCopyWithImpl<$Res>
    implements $SearchPopupStateCopyWith<$Res> {
  _$SearchPopupStateCopyWithImpl(this._self, this._then);

  final SearchPopupState _self;
  final $Res Function(SearchPopupState) _then;

/// Create a copy of SearchPopupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loadingDiscover = null,Object? loadingPodcasts = null,Object? loadingEpisodes = null,Object? discoverResults = null,Object? podcastResults = null,Object? episodeResults = null,}) {
  return _then(_self.copyWith(
loadingDiscover: null == loadingDiscover ? _self.loadingDiscover : loadingDiscover // ignore: cast_nullable_to_non_nullable
as bool,loadingPodcasts: null == loadingPodcasts ? _self.loadingPodcasts : loadingPodcasts // ignore: cast_nullable_to_non_nullable
as bool,loadingEpisodes: null == loadingEpisodes ? _self.loadingEpisodes : loadingEpisodes // ignore: cast_nullable_to_non_nullable
as bool,discoverResults: null == discoverResults ? _self.discoverResults : discoverResults // ignore: cast_nullable_to_non_nullable
as List<SearchResult>,podcastResults: null == podcastResults ? _self.podcastResults : podcastResults // ignore: cast_nullable_to_non_nullable
as List<PodcastLight>,episodeResults: null == episodeResults ? _self.episodeResults : episodeResults // ignore: cast_nullable_to_non_nullable
as List<Episode>,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchPopupState].
extension SearchPopupStatePatterns on SearchPopupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchPopupState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchPopupState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchPopupState value)  $default,){
final _that = this;
switch (_that) {
case _SearchPopupState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchPopupState value)?  $default,){
final _that = this;
switch (_that) {
case _SearchPopupState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loadingDiscover,  bool loadingPodcasts,  bool loadingEpisodes,  List<SearchResult> discoverResults,  List<PodcastLight> podcastResults,  List<Episode> episodeResults)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchPopupState() when $default != null:
return $default(_that.loadingDiscover,_that.loadingPodcasts,_that.loadingEpisodes,_that.discoverResults,_that.podcastResults,_that.episodeResults);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loadingDiscover,  bool loadingPodcasts,  bool loadingEpisodes,  List<SearchResult> discoverResults,  List<PodcastLight> podcastResults,  List<Episode> episodeResults)  $default,) {final _that = this;
switch (_that) {
case _SearchPopupState():
return $default(_that.loadingDiscover,_that.loadingPodcasts,_that.loadingEpisodes,_that.discoverResults,_that.podcastResults,_that.episodeResults);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loadingDiscover,  bool loadingPodcasts,  bool loadingEpisodes,  List<SearchResult> discoverResults,  List<PodcastLight> podcastResults,  List<Episode> episodeResults)?  $default,) {final _that = this;
switch (_that) {
case _SearchPopupState() when $default != null:
return $default(_that.loadingDiscover,_that.loadingPodcasts,_that.loadingEpisodes,_that.discoverResults,_that.podcastResults,_that.episodeResults);case _:
  return null;

}
}

}

/// @nodoc


class _SearchPopupState implements SearchPopupState {
  const _SearchPopupState({this.loadingDiscover = false, this.loadingPodcasts = false, this.loadingEpisodes = false, final  List<SearchResult> discoverResults = const [], final  List<PodcastLight> podcastResults = const [], final  List<Episode> episodeResults = const []}): _discoverResults = discoverResults,_podcastResults = podcastResults,_episodeResults = episodeResults;
  

@override@JsonKey() final  bool loadingDiscover;
@override@JsonKey() final  bool loadingPodcasts;
@override@JsonKey() final  bool loadingEpisodes;
 final  List<SearchResult> _discoverResults;
@override@JsonKey() List<SearchResult> get discoverResults {
  if (_discoverResults is EqualUnmodifiableListView) return _discoverResults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_discoverResults);
}

 final  List<PodcastLight> _podcastResults;
@override@JsonKey() List<PodcastLight> get podcastResults {
  if (_podcastResults is EqualUnmodifiableListView) return _podcastResults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_podcastResults);
}

 final  List<Episode> _episodeResults;
@override@JsonKey() List<Episode> get episodeResults {
  if (_episodeResults is EqualUnmodifiableListView) return _episodeResults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_episodeResults);
}


/// Create a copy of SearchPopupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchPopupStateCopyWith<_SearchPopupState> get copyWith => __$SearchPopupStateCopyWithImpl<_SearchPopupState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchPopupState&&(identical(other.loadingDiscover, loadingDiscover) || other.loadingDiscover == loadingDiscover)&&(identical(other.loadingPodcasts, loadingPodcasts) || other.loadingPodcasts == loadingPodcasts)&&(identical(other.loadingEpisodes, loadingEpisodes) || other.loadingEpisodes == loadingEpisodes)&&const DeepCollectionEquality().equals(other._discoverResults, _discoverResults)&&const DeepCollectionEquality().equals(other._podcastResults, _podcastResults)&&const DeepCollectionEquality().equals(other._episodeResults, _episodeResults));
}


@override
int get hashCode => Object.hash(runtimeType,loadingDiscover,loadingPodcasts,loadingEpisodes,const DeepCollectionEquality().hash(_discoverResults),const DeepCollectionEquality().hash(_podcastResults),const DeepCollectionEquality().hash(_episodeResults));

@override
String toString() {
  return 'SearchPopupState(loadingDiscover: $loadingDiscover, loadingPodcasts: $loadingPodcasts, loadingEpisodes: $loadingEpisodes, discoverResults: $discoverResults, podcastResults: $podcastResults, episodeResults: $episodeResults)';
}


}

/// @nodoc
abstract mixin class _$SearchPopupStateCopyWith<$Res> implements $SearchPopupStateCopyWith<$Res> {
  factory _$SearchPopupStateCopyWith(_SearchPopupState value, $Res Function(_SearchPopupState) _then) = __$SearchPopupStateCopyWithImpl;
@override @useResult
$Res call({
 bool loadingDiscover, bool loadingPodcasts, bool loadingEpisodes, List<SearchResult> discoverResults, List<PodcastLight> podcastResults, List<Episode> episodeResults
});




}
/// @nodoc
class __$SearchPopupStateCopyWithImpl<$Res>
    implements _$SearchPopupStateCopyWith<$Res> {
  __$SearchPopupStateCopyWithImpl(this._self, this._then);

  final _SearchPopupState _self;
  final $Res Function(_SearchPopupState) _then;

/// Create a copy of SearchPopupState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loadingDiscover = null,Object? loadingPodcasts = null,Object? loadingEpisodes = null,Object? discoverResults = null,Object? podcastResults = null,Object? episodeResults = null,}) {
  return _then(_SearchPopupState(
loadingDiscover: null == loadingDiscover ? _self.loadingDiscover : loadingDiscover // ignore: cast_nullable_to_non_nullable
as bool,loadingPodcasts: null == loadingPodcasts ? _self.loadingPodcasts : loadingPodcasts // ignore: cast_nullable_to_non_nullable
as bool,loadingEpisodes: null == loadingEpisodes ? _self.loadingEpisodes : loadingEpisodes // ignore: cast_nullable_to_non_nullable
as bool,discoverResults: null == discoverResults ? _self._discoverResults : discoverResults // ignore: cast_nullable_to_non_nullable
as List<SearchResult>,podcastResults: null == podcastResults ? _self._podcastResults : podcastResults // ignore: cast_nullable_to_non_nullable
as List<PodcastLight>,episodeResults: null == episodeResults ? _self._episodeResults : episodeResults // ignore: cast_nullable_to_non_nullable
as List<Episode>,
  ));
}


}

// dart format on
