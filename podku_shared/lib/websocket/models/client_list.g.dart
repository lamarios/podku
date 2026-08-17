// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ClientList _$ClientListFromJson(Map<String, dynamic> json) => _ClientList(
  currentPlayer: json['currentPlayer'] == null
      ? null
      : PlayerInfo.fromJson(json['currentPlayer'] as Map<String, dynamic>),
  clients:
      (json['clients'] as List<dynamic>?)
          ?.map((e) => PlayerInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ClientListToJson(_ClientList instance) =>
    <String, dynamic>{
      'currentPlayer': instance.currentPlayer,
      'clients': instance.clients,
    };
