import 'package:audio_service/audio_service.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podku/episodes/models/episode_url.dart';
import 'package:podku/podcasts/models/podcast.dart';
import 'package:podku_client/podku_client.dart';

class PodkuAudioHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer();

  PodkuAudioHandler() {
    init();
  }

  void init() {
    _player.playerStateStream.listen(updatePlayerState);
    _player.bufferedPositionStream.listen(updateBuffering);
    _player.positionStream.listen(updatePosition);
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> skipToNext() {
    return fastForward();
  }

  @override
  Future<void> skipToPrevious() {
    return rewind();
  }

  @override
  Future<void> seek(Duration position) async {
    _player.seek(position);
    playbackState.add(playbackState.value.copyWith(updatePosition: position));
  }

  @override
  Future<void> fastForward() async {
    var position = _player.position + Duration(seconds: 30);
    _player.seek(position);

    playbackState.add(playbackState.value.copyWith(updatePosition: position));
  }

  @override
  Future<void> rewind() async {
    var position = _player.position + Duration(seconds: -10);
    _player.seek(position);
    playbackState.add(playbackState.value.copyWith(updatePosition: position));
  }

  Future<void> playEpisode(Episode episode) async {
    playbackState.add(playbackState.value.copyWith(processingState: .loading));


    var audioProxyUrl = episode.audioProxyUrl;
    await _player.setUrl(audioProxyUrl);
    final item = MediaItem(
      id: episode.id.uuid,
      title: episode.title,
      artist: episode.podcast?.name,
      duration: Duration(seconds: episode.durationSeconds ?? 1),
      artUri: Uri.tryParse(episode.podcast?.artUrl ?? ''),
    );

    mediaItem.add(item);
    playbackState.add(
      PlaybackState(
        queueIndex: 0,
        controls: [
          .pause,
          .rewind,
          .fastForward,
        ],
        systemActions: {.seek, .seekBackward, .seekForward},
        androidCompactActionIndices: [
          0,
          2,
          1,
        ],
        processingState: .loading,
        updatePosition: Duration.zero,
        bufferedPosition: Duration.zero,

        playing: true,
        speed: 1,
      ),
    );
  }

  void updatePlayerState(PlayerState event) {
    print('new player state: ${event.processingState}');
    var newState = playbackState.value.copyWith(
      playing: event.playing,
      processingState: switch (event.processingState) {
        .completed => .completed,
        .loading => .loading,
        .ready => .ready,
        .buffering => .buffering,
        .idle => .idle,
      },
    );

    playbackState.add(newState);
  }

  void updateBuffering(Duration event) {
    EasyThrottle.throttle('player-update-buffer', Duration(seconds: 1), () {
      playbackState.add(playbackState.value.copyWith(bufferedPosition: event));
    });
  }

  void updatePosition(Duration event) {
    EasyThrottle.throttle('player-update-position', Duration(seconds: 1), () {
      playbackState.add(playbackState.value.copyWith(updatePosition: event));
    });
  }
}
