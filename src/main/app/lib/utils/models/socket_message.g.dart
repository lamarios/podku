// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PodkuSocketMessage _$PodkuSocketMessageFromJson(Map<String, dynamic> json) => _PodkuSocketMessage(
  message: json['message'] as Map<String, dynamic>?,
  type: $enumDecode(_$PodkuSocketMessageTypeEnumMap, json['type']),
);

Map<String, dynamic> _$PodkuSocketMessageToJson(_PodkuSocketMessage instance) => <String, dynamic>{
  'message': instance.message,
  'type': _$PodkuSocketMessageTypeEnumMap[instance.type]!,
};

const _$PodkuSocketMessageTypeEnumMap = {
  PodkuSocketMessageType.playbackProgress: 'playbackProgress',
  PodkuSocketMessageType.getPlayerStatus: 'getPlayerStatus',
  PodkuSocketMessageType.remoteCommand: 'remoteCommand',
  PodkuSocketMessageType.playerInfo: 'playerInfo',
  PodkuSocketMessageType.playerStatus: 'playerStatus',
  PodkuSocketMessageType.clientList: 'clientList',
  PodkuSocketMessageType.transferPlayback: 'transferPlayback',
};
