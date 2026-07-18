/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class EpisodeProgress implements _i1.SerializableModel {
  EpisodeProgress._({
    required this.episodeId,
    required this.progress,
    required this.player,
    required this.newPlayback,
  });

  factory EpisodeProgress({
    required _i1.UuidValue episodeId,
    required double progress,
    required _i1.UuidValue player,
    required bool newPlayback,
  }) = _EpisodeProgressImpl;

  factory EpisodeProgress.fromJson(Map<String, dynamic> jsonSerialization) {
    return EpisodeProgress(
      episodeId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['episodeId'],
      ),
      progress: (jsonSerialization['progress'] as num).toDouble(),
      player: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['player']),
      newPlayback: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['newPlayback'],
      ),
    );
  }

  _i1.UuidValue episodeId;

  double progress;

  _i1.UuidValue player;

  bool newPlayback;

  /// Returns a shallow copy of this [EpisodeProgress]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EpisodeProgress copyWith({
    _i1.UuidValue? episodeId,
    double? progress,
    _i1.UuidValue? player,
    bool? newPlayback,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EpisodeProgress',
      'episodeId': episodeId.toJson(),
      'progress': progress,
      'player': player.toJson(),
      'newPlayback': newPlayback,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _EpisodeProgressImpl extends EpisodeProgress {
  _EpisodeProgressImpl({
    required _i1.UuidValue episodeId,
    required double progress,
    required _i1.UuidValue player,
    required bool newPlayback,
  }) : super._(
         episodeId: episodeId,
         progress: progress,
         player: player,
         newPlayback: newPlayback,
       );

  /// Returns a shallow copy of this [EpisodeProgress]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EpisodeProgress copyWith({
    _i1.UuidValue? episodeId,
    double? progress,
    _i1.UuidValue? player,
    bool? newPlayback,
  }) {
    return EpisodeProgress(
      episodeId: episodeId ?? this.episodeId,
      progress: progress ?? this.progress,
      player: player ?? this.player,
      newPlayback: newPlayback ?? this.newPlayback,
    );
  }
}
