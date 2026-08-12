import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:podku_shared/websocket/models/player_info.dart';

part 'client_list.freezed.dart';
part 'client_list.g.dart';

@freezed
sealed class ClientList with _$ClientList {
  const factory ClientList({@Default([]) List<PlayerInfo> clients}) = _ClientList;

  factory ClientList.fromJson(Map<String, Object?> json) => _$ClientListFromJson(json);
}
