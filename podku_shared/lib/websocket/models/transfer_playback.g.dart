// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_playback.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransferPlayback _$TransferPlaybackFromJson(Map<String, dynamic> json) =>
    _TransferPlayback(
      episode: Episode.fromJson(json['episode'] as Map<String, dynamic>),
      position: (json['position'] as num).toInt(),
      playerId: json['playerId'] as String,
    );

Map<String, dynamic> _$TransferPlaybackToJson(_TransferPlayback instance) =>
    <String, dynamic>{
      'episode': instance.episode,
      'position': instance.position,
      'playerId': instance.playerId,
    };
