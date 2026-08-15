// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RemoteCommand _$RemoteCommandFromJson(Map<String, dynamic> json) =>
    _RemoteCommand(
      type: $enumDecode(_$CommandTypeEnumMap, json['type']),
      episode: json['episode'] == null
          ? null
          : Episode.fromJson(json['episode'] as Map<String, dynamic>),
      position: (json['position'] as num?)?.toInt(),
      speed: (json['speed'] as num?)?.toDouble(),
      volume: (json['volume'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$RemoteCommandToJson(_RemoteCommand instance) =>
    <String, dynamic>{
      'type': _$CommandTypeEnumMap[instance.type]!,
      'episode': instance.episode,
      'position': instance.position,
      'speed': instance.speed,
      'volume': instance.volume,
    };

const _$CommandTypeEnumMap = {
  CommandType.play: 'play',
  CommandType.pause: 'pause',
  CommandType.stop: 'stop',
  CommandType.skipForward: 'skipForward',
  CommandType.rewind: 'rewind',
  CommandType.setEpisode: 'setEpisode',
  CommandType.seek: 'seek',
  CommandType.setSpeed: 'setSpeed',
  CommandType.setVolume: 'setVolume',
};
