import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openapi/openapi.dart';

part 'remote_command.freezed.dart';

part 'remote_command.g.dart';

@freezed
sealed class RemoteCommand with _$RemoteCommand {
  const factory RemoteCommand({required CommandType type, Episode? episode, int? position, double? speed, double? volume}) =
      _RemoteCommand;

  factory RemoteCommand.fromJson(Map<String, Object?> json) => _$RemoteCommandFromJson(json);
}

enum CommandType { play, pause, stop, skipForward, rewind, setEpisode, seek, setSpeed, setVolume }
