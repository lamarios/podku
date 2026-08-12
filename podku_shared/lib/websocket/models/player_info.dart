import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_info.freezed.dart';
part 'player_info.g.dart';

@freezed
sealed class PlayerInfo with _$PlayerInfo {
  const factory PlayerInfo({required String id, required String name}) = _PlayerInfo;

  factory PlayerInfo.fromJson(Map<String, Object?> json) => _$PlayerInfoFromJson(json);
}
