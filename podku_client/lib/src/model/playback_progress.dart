//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'playback_progress.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PlaybackProgress {
  /// Returns a new [PlaybackProgress] instance.
  PlaybackProgress({

     this.episodeId,

     this.progress,

     this.player,

     this.newPlayback,
  });

  @JsonKey(
    
    name: r'episodeId',
    required: false,
    includeIfNull: false,
  )


  final String? episodeId;



  @JsonKey(
    
    name: r'progress',
    required: false,
    includeIfNull: false,
  )


  final double? progress;



  @JsonKey(
    
    name: r'player',
    required: false,
    includeIfNull: false,
  )


  final String? player;



  @JsonKey(
    
    name: r'newPlayback',
    required: false,
    includeIfNull: false,
  )


  final bool? newPlayback;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PlaybackProgress &&
      other.episodeId == episodeId &&
      other.progress == progress &&
      other.player == player &&
      other.newPlayback == newPlayback;

    @override
    int get hashCode =>
        episodeId.hashCode +
        progress.hashCode +
        player.hashCode +
        newPlayback.hashCode;

  factory PlaybackProgress.fromJson(Map<String, dynamic> json) => _$PlaybackProgressFromJson(json);

  Map<String, dynamic> toJson() => _$PlaybackProgressToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

