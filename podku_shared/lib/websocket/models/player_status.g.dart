// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlayerStatus _$PlayerStatusFromJson(Map<String, dynamic> json) =>
    _PlayerStatus(
      client: json['client'] == null
          ? null
          : PlayerInfo.fromJson(json['client'] as Map<String, dynamic>),
      episode: json['episode'] == null
          ? null
          : Episode.fromJson(json['episode'] as Map<String, dynamic>),
      position: (json['position'] as num).toInt(),
      duration: (json['duration'] as num).toInt(),
      speed: (json['speed'] as num).toDouble(),
      playing: json['playing'] as bool? ?? false,
      broadcast: json['broadcast'] as bool? ?? true,
    );

Map<String, dynamic> _$PlayerStatusToJson(_PlayerStatus instance) =>
    <String, dynamic>{
      'client': instance.client,
      'episode': instance.episode,
      'position': instance.position,
      'duration': instance.duration,
      'speed': instance.speed,
      'playing': instance.playing,
      'broadcast': instance.broadcast,
    };
