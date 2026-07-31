// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playback_progress.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PlaybackProgressCWProxy {
  PlaybackProgress episodeId(String? episodeId);

  PlaybackProgress progress(double? progress);

  PlaybackProgress player(String? player);

  PlaybackProgress newPlayback(bool? newPlayback);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PlaybackProgress(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PlaybackProgress(...).copyWith(id: 12, name: "My name")
  /// ````
  PlaybackProgress call({
    String? episodeId,
    double? progress,
    String? player,
    bool? newPlayback,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPlaybackProgress.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPlaybackProgress.copyWith.fieldName(...)`
class _$PlaybackProgressCWProxyImpl implements _$PlaybackProgressCWProxy {
  const _$PlaybackProgressCWProxyImpl(this._value);

  final PlaybackProgress _value;

  @override
  PlaybackProgress episodeId(String? episodeId) => this(episodeId: episodeId);

  @override
  PlaybackProgress progress(double? progress) => this(progress: progress);

  @override
  PlaybackProgress player(String? player) => this(player: player);

  @override
  PlaybackProgress newPlayback(bool? newPlayback) =>
      this(newPlayback: newPlayback);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PlaybackProgress(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PlaybackProgress(...).copyWith(id: 12, name: "My name")
  /// ````
  PlaybackProgress call({
    Object? episodeId = const $CopyWithPlaceholder(),
    Object? progress = const $CopyWithPlaceholder(),
    Object? player = const $CopyWithPlaceholder(),
    Object? newPlayback = const $CopyWithPlaceholder(),
  }) {
    return PlaybackProgress(
      episodeId: episodeId == const $CopyWithPlaceholder()
          ? _value.episodeId
          // ignore: cast_nullable_to_non_nullable
          : episodeId as String?,
      progress: progress == const $CopyWithPlaceholder()
          ? _value.progress
          // ignore: cast_nullable_to_non_nullable
          : progress as double?,
      player: player == const $CopyWithPlaceholder()
          ? _value.player
          // ignore: cast_nullable_to_non_nullable
          : player as String?,
      newPlayback: newPlayback == const $CopyWithPlaceholder()
          ? _value.newPlayback
          // ignore: cast_nullable_to_non_nullable
          : newPlayback as bool?,
    );
  }
}

extension $PlaybackProgressCopyWith on PlaybackProgress {
  /// Returns a callable class that can be used as follows: `instanceOfPlaybackProgress.copyWith(...)` or like so:`instanceOfPlaybackProgress.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PlaybackProgressCWProxy get copyWith => _$PlaybackProgressCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaybackProgress _$PlaybackProgressFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PlaybackProgress', json, ($checkedConvert) {
      final val = PlaybackProgress(
        episodeId: $checkedConvert('episodeId', (v) => v as String?),
        progress: $checkedConvert('progress', (v) => (v as num?)?.toDouble()),
        player: $checkedConvert('player', (v) => v as String?),
        newPlayback: $checkedConvert('newPlayback', (v) => v as bool?),
      );
      return val;
    });

Map<String, dynamic> _$PlaybackProgressToJson(PlaybackProgress instance) =>
    <String, dynamic>{
      'episodeId': ?instance.episodeId,
      'progress': ?instance.progress,
      'player': ?instance.player,
      'newPlayback': ?instance.newPlayback,
    };
