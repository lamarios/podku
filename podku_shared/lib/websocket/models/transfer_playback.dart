import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openapi/openapi.dart';

part 'transfer_playback.freezed.dart';

part 'transfer_playback.g.dart';

@freezed
sealed class TransferPlayback with _$TransferPlayback {
  const factory TransferPlayback({required Episode episode, required int position, required String playerId}) =
      _TransferPlayback;

  factory TransferPlayback.fromJson(Map<String, Object?> json) => _$TransferPlaybackFromJson(json);
}
