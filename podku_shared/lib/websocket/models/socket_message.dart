import 'package:freezed_annotation/freezed_annotation.dart';

part 'socket_message.freezed.dart';

part 'socket_message.g.dart';

enum PodkuSocketMessageType {
  playbackProgress,
  getPlayerStatus,
  remoteCommand,
  playerInfo,
  playerStatus,
  clientList,
  transferPlayback,
}

@freezed
sealed class PodkuSocketMessage with _$PodkuSocketMessage {
  const factory PodkuSocketMessage({required Map<String, dynamic>? message, required PodkuSocketMessageType type}) =
      _PodkuSocketMessage;

  factory PodkuSocketMessage.fromJson(Map<String, Object?> json) => _$PodkuSocketMessageFromJson(json);
}
