// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'download_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DownloadProgress {

 String get id; TaskStatus get status; double get progress; int get retries;
/// Create a copy of DownloadProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DownloadProgressCopyWith<DownloadProgress> get copyWith => _$DownloadProgressCopyWithImpl<DownloadProgress>(this as DownloadProgress, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadProgress&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.retries, retries) || other.retries == retries));
}


@override
int get hashCode => Object.hash(runtimeType,id,status,progress,retries);

@override
String toString() {
  return 'DownloadProgress(id: $id, status: $status, progress: $progress, retries: $retries)';
}


}

/// @nodoc
abstract mixin class $DownloadProgressCopyWith<$Res>  {
  factory $DownloadProgressCopyWith(DownloadProgress value, $Res Function(DownloadProgress) _then) = _$DownloadProgressCopyWithImpl;
@useResult
$Res call({
 String id, TaskStatus status, double progress, int retries
});




}
/// @nodoc
class _$DownloadProgressCopyWithImpl<$Res>
    implements $DownloadProgressCopyWith<$Res> {
  _$DownloadProgressCopyWithImpl(this._self, this._then);

  final DownloadProgress _self;
  final $Res Function(DownloadProgress) _then;

/// Create a copy of DownloadProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? progress = null,Object? retries = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,retries: null == retries ? _self.retries : retries // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DownloadProgress].
extension DownloadProgressPatterns on DownloadProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DownloadProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DownloadProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DownloadProgress value)  $default,){
final _that = this;
switch (_that) {
case _DownloadProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DownloadProgress value)?  $default,){
final _that = this;
switch (_that) {
case _DownloadProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  TaskStatus status,  double progress,  int retries)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DownloadProgress() when $default != null:
return $default(_that.id,_that.status,_that.progress,_that.retries);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  TaskStatus status,  double progress,  int retries)  $default,) {final _that = this;
switch (_that) {
case _DownloadProgress():
return $default(_that.id,_that.status,_that.progress,_that.retries);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  TaskStatus status,  double progress,  int retries)?  $default,) {final _that = this;
switch (_that) {
case _DownloadProgress() when $default != null:
return $default(_that.id,_that.status,_that.progress,_that.retries);case _:
  return null;

}
}

}

/// @nodoc


class _DownloadProgress implements DownloadProgress {
  const _DownloadProgress({required this.id, required this.status, required this.progress, this.retries = 0});
  

@override final  String id;
@override final  TaskStatus status;
@override final  double progress;
@override@JsonKey() final  int retries;

/// Create a copy of DownloadProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DownloadProgressCopyWith<_DownloadProgress> get copyWith => __$DownloadProgressCopyWithImpl<_DownloadProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DownloadProgress&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.retries, retries) || other.retries == retries));
}


@override
int get hashCode => Object.hash(runtimeType,id,status,progress,retries);

@override
String toString() {
  return 'DownloadProgress(id: $id, status: $status, progress: $progress, retries: $retries)';
}


}

/// @nodoc
abstract mixin class _$DownloadProgressCopyWith<$Res> implements $DownloadProgressCopyWith<$Res> {
  factory _$DownloadProgressCopyWith(_DownloadProgress value, $Res Function(_DownloadProgress) _then) = __$DownloadProgressCopyWithImpl;
@override @useResult
$Res call({
 String id, TaskStatus status, double progress, int retries
});




}
/// @nodoc
class __$DownloadProgressCopyWithImpl<$Res>
    implements _$DownloadProgressCopyWith<$Res> {
  __$DownloadProgressCopyWithImpl(this._self, this._then);

  final _DownloadProgress _self;
  final $Res Function(_DownloadProgress) _then;

/// Create a copy of DownloadProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? progress = null,Object? retries = null,}) {
  return _then(_DownloadProgress(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,retries: null == retries ? _self.retries : retries // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
