// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_progress.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$OfflineProgressCWProxy {
  OfflineProgress timeOfProgress(int? timeOfProgress);

  OfflineProgress progress(int? progress);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OfflineProgress(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OfflineProgress(...).copyWith(id: 12, name: "My name")
  /// ````
  OfflineProgress call({int? timeOfProgress, int? progress});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfOfflineProgress.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfOfflineProgress.copyWith.fieldName(...)`
class _$OfflineProgressCWProxyImpl implements _$OfflineProgressCWProxy {
  const _$OfflineProgressCWProxyImpl(this._value);

  final OfflineProgress _value;

  @override
  OfflineProgress timeOfProgress(int? timeOfProgress) =>
      this(timeOfProgress: timeOfProgress);

  @override
  OfflineProgress progress(int? progress) => this(progress: progress);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OfflineProgress(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OfflineProgress(...).copyWith(id: 12, name: "My name")
  /// ````
  OfflineProgress call({
    Object? timeOfProgress = const $CopyWithPlaceholder(),
    Object? progress = const $CopyWithPlaceholder(),
  }) {
    return OfflineProgress(
      timeOfProgress: timeOfProgress == const $CopyWithPlaceholder()
          ? _value.timeOfProgress
          // ignore: cast_nullable_to_non_nullable
          : timeOfProgress as int?,
      progress: progress == const $CopyWithPlaceholder()
          ? _value.progress
          // ignore: cast_nullable_to_non_nullable
          : progress as int?,
    );
  }
}

extension $OfflineProgressCopyWith on OfflineProgress {
  /// Returns a callable class that can be used as follows: `instanceOfOfflineProgress.copyWith(...)` or like so:`instanceOfOfflineProgress.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$OfflineProgressCWProxy get copyWith => _$OfflineProgressCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfflineProgress _$OfflineProgressFromJson(Map<String, dynamic> json) =>
    $checkedCreate('OfflineProgress', json, ($checkedConvert) {
      final val = OfflineProgress(
        timeOfProgress: $checkedConvert(
          'timeOfProgress',
          (v) => (v as num?)?.toInt(),
        ),
        progress: $checkedConvert('progress', (v) => (v as num?)?.toInt()),
      );
      return val;
    });

Map<String, dynamic> _$OfflineProgressToJson(OfflineProgress instance) =>
    <String, dynamic>{
      'timeOfProgress': ?instance.timeOfProgress,
      'progress': ?instance.progress,
    };
