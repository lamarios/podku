import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openapi/openapi.dart';

part 'player_status.freezed.dart';

part 'player_status.g.dart';

@freezed
sealed class PlayerStatus with _$PlayerStatus {
  const factory PlayerStatus({
    required Episode? episode,
    required int position,
    required int duration,
    required double speed,
    @Default(false) bool playing,
    @Default(true) bool broadcast,
    @Default(100) double volume
  }) = _PlayerStatus;

  factory PlayerStatus.fromJson(Map<String, Object?> json) => _$PlayerStatusFromJson(json);
}
