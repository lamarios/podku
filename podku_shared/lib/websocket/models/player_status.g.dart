// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlayerStatus _$PlayerStatusFromJson(Map<String, dynamic> json) =>
    _PlayerStatus(
      episode: json['episode'] == null
          ? null
          : Episode.fromJson(json['episode'] as Map<String, dynamic>),
      position: (json['position'] as num).toInt(),
      duration: (json['duration'] as num).toInt(),
      speed: (json['speed'] as num).toDouble(),
      playing: json['playing'] as bool? ?? false,
      broadcast: json['broadcast'] as bool? ?? true,
      volume: (json['volume'] as num?)?.toDouble() ?? 100,
    );

Map<String, dynamic> _$PlayerStatusToJson(_PlayerStatus instance) =>
    <String, dynamic>{
      'episode': instance.episode,
      'position': instance.position,
      'duration': instance.duration,
      'speed': instance.speed,
      'playing': instance.playing,
      'broadcast': instance.broadcast,
      'volume': instance.volume,
    };
