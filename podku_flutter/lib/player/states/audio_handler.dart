import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:podku/episodes/models/episode_downloads.dart';
import 'package:podku/episodes/models/episode_url.dart';
import 'package:podku/main.dart';
import 'package:podku/offline_episodes/states/download_manager.dart';
import 'package:podku/podcasts/models/podcast.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/android_file_provider.dart';
import 'package:podku_client/podku_client.dart';

const _autoMain = 'main';
const _autoEpisodes = 'episodes';
const _autoPodcast = 'podcast-';
const _autoOfflineList = 'offline';
const _autoOffline = 'offline-';

class PodkuAudioHandler extends BaseAudioHandler with SeekHandler {
  static final _log = Logger('PodkuAudioHandler');
  final _player = AudioPlayer();

  PodkuAudioHandler() {
    init();
  }

  void init() {
    _player.onPlayerStateChanged.listen(updatePlayerState);
    // _player.bufferedPositionStream.listen(updateBuffering);
    _player.onPositionChanged.listen(updatePosition);
    _player.setReleaseMode(.stop);
  }

  @override
  Future<void> play() async {
    _log.fine('play');
    _player.resume();
  }

  @override
  Future<void> pause() async {
    _log.fine('Pause');
    _player.pause();
  }

  @override
  Future<void> stop() async {
    _log.fine('stop');
    _player.stop();
  }

  @override
  Future<void> skipToNext() {
    return fastForward();
  }

  @override
  Future<void> skipToPrevious() {
    return rewind();
  }

  @override
  Future<List<MediaItem>> getChildren(String parentMediaId, [Map<String, dynamic>? options]) async {
    _log.fine('Getting android auto children for parent: $parentMediaId');
    final serverCubit = getIt.get<ServerCubit>();
    if ((await serverCubit.waitForClientToBeSet()) == null) {
      _log.fine('could not get a client');
      return [];
    }

    List<MediaItem> items = [];
    if (parentMediaId == AudioService.browsableRootId) {
      items.add(
        MediaItem(
          id: _autoMain,
          title: 'Podku',
          playable: false,
          extras: {
            'android.media.browse.CONTENT_STYLE_BROWSABLE_HINT': 2, // grid
            'android.media.browse.CONTENT_STYLE_PLAYABLE_HINT': 1, // list
          },
        ),
      );
    } else if (parentMediaId == _autoMain) {
      items.add(
        MediaItem(
          id: _autoEpisodes,
          title: 'Latest',
          playable: false,
          artUri: Uri.parse('android.resource://com.github.lamarios.podku/mipmap/ic_launcher'),
          extras: {
            'android.media.browse.CONTENT_STYLE_BROWSABLE_HINT': 2, // grid
            'android.media.browse.CONTENT_STYLE_PLAYABLE_HINT': 1, // list
          },
        ),
      );

      items.add(
        MediaItem(
          id: _autoOfflineList,
          title: 'Downloaded',
          playable: false,
          artUri: Uri.parse('android.resource://com.github.lamarios.podku/mipmap/ic_launcher'),
          extras: {
            'android.media.browse.CONTENT_STYLE_BROWSABLE_HINT': 2, // grid
            'android.media.browse.CONTENT_STYLE_PLAYABLE_HINT': 1, // list
          },
        ),
      );
      try {
        final podcasts = await client.podcast.getPodcasts();
        for (final p in podcasts) {
          items.add(
            MediaItem(
              id: '$_autoPodcast${p.id.uuid}',
              title: p.name,
              playable: false,
              artUri: p.artUri,
              extras: {
                'android.media.browse.CONTENT_STYLE_BROWSABLE_HINT': 2, // grid
                'android.media.browse.CONTENT_STYLE_PLAYABLE_HINT': 1, // list
              },
            ),
          );
        }
      } catch (e) {
        _log.fine('Could not get podcasts, it is probably ok');
      }
    } else if (parentMediaId == _autoEpisodes) {
      final episodes = await client.episodes.getEpisodes(pageSize: 100);

      for (final episode in episodes) {
        items.add(_episodeForAndroidAuto(episode));
      }
    } else if (parentMediaId.startsWith(_autoPodcast)) {
      final podcast = await client.podcast.getPodcast(parentMediaId.replaceFirst(_autoPodcast, ''));

      if (podcast != null) {
        items.addAll(
          podcast.episodes?.map((e) => _episodeForAndroidAuto(e.copyWith(podcast: podcast.copyWith(episodes: [])))) ??
              [],
        );
      }
    } else if (parentMediaId.startsWith(_autoOfflineList)) {
      final episodes = getIt.get<DownloadManagerCubit>().state.offlineEpisodes;

      for (final e in episodes) {
        var imageFile = await e.offlineFiles.then((value) => value.where((n) => n.endsWith(e.imageFile)).firstOrNull);

        final artUri = imageFile == null
            ? e.podcast?.artUri
            : await AndroidFileProvider.getContentUriForFile(imageFile);

        _log.fine('file uri: $artUri');
        final media = _episodeForAndroidAuto(e).copyWith(id: '$_autoOffline${e.id.uuid}', artUri: artUri);

        items.add(media);
      }
    }
    return items; // no deeper nesting needed
  }

  MediaItem _episodeForAndroidAuto(Episode episode) {
    return MediaItem(
      id: episode.id.uuid,
      title: episode.title,
      artist: episode.podcast?.name,
      duration: Duration(seconds: episode.durationSeconds ?? 1),
      playable: true,
      artUri: Uri.tryParse(episode.podcast?.artUrl ?? ''),

      extras: {
        // Completion status — key AND value are different from what I said earlier
        'android.media.extra.PLAYBACK_STATUS': episode.progress > 0.95
            ? 2 // DESCRIPTION_EXTRAS_VALUE_COMPLETION_STATUS_FULLY_PLAYED
            : episode.progress > 0
            ? 1 // ...PARTIALLY_PLAYED
            : 0,
        // ...NOT_PLAYED

        // Completion percentage
        'androidx.media.MediaItem.Extras.COMPLETION_PERCENTAGE': episode.progress,
        // double 0.0–1.0
      },
    );
  }

  @override
  Future<void> playFromMediaId(String mediaId, [Map<String, dynamic>? extras]) async {
    _log.fine("playing from mediaId: $mediaId");
    final Episode? episode;
    if (mediaId.startsWith(_autoOffline)) {
      episode = getIt
          .get<DownloadManagerCubit>()
          .state
          .offlineEpisodes
          .where((element) => element.id.uuid == mediaId.replaceFirst(_autoOffline, ''))
          .firstOrNull;
    } else {
      episode = await client.episodes.getEpisode(UuidValue.fromString(mediaId));
    }
    if (episode != null) {
      await playEpisode(episode);
      await play();
    }
  }

  @override
  Future<void> seek(Duration position) async {
    _player.seek(position);
    playbackState.add(playbackState.value.copyWith(updatePosition: position));
  }

  @override
  Future<void> fastForward() async {
    var position = (await _player.getCurrentPosition() ?? Duration.zero) + Duration(seconds: 30);
    _player.seek(position);

    playbackState.add(playbackState.value.copyWith(updatePosition: position));
  }

  @override
  Future<void> rewind() async {
    var position = (await _player.getCurrentPosition() ?? Duration(seconds: 10)) + Duration(seconds: -10);
    _player.seek(position);
    playbackState.add(playbackState.value.copyWith(updatePosition: position));
  }

  Future<void> playEpisode(Episode episode) async {
    playbackState.add(playbackState.value.copyWith(processingState: .loading));

    // we should try to get the latest version of the episode for up to date progress
    try {
      episode = await client.episodes.getEpisode(episode.id) ?? episode;
    } catch (e) {
      _log.warning("Couldn't get the episode before playing, we're probably offline");
    }

    var offlineFiles = kIsWeb ? [] : await episode.offlineFiles;

    final offlineFile = offlineFiles.where((s) => s.endsWith(episode.episodeFile)).firstOrNull;

    var imageFile = offlineFiles.where((n) => n.endsWith(episode.imageFile)).firstOrNull;

    final artUri = imageFile == null
        ? episode.podcast?.artUri
        : await AndroidFileProvider.getContentUriForFile(imageFile);

    var audioProxyUrl = episode.audioProxyUrl;

    final initialPosition = episode.durationSeconds == null
        ? Duration.zero
        : Duration(seconds: (episode.progress.clamp(0, 1) * episode.durationSeconds!).round());

    if (offlineFile != null) {
      _log.fine('playing from offline file');
      await _player.setSourceDeviceFile(offlineFile);
    } else {
      _log.fine('playing online');
      await _player.setSourceUrl(audioProxyUrl);
    }

    await _player.seek(initialPosition);

    final item = MediaItem(
      id: episode.id.uuid,
      title: episode.title,
      artist: episode.podcast?.name,
      duration: Duration(seconds: episode.durationSeconds ?? 1),
      artUri: artUri,
    );

    mediaItem.add(item);
    playbackState.add(
      PlaybackState(
        queueIndex: 0,
        controls: [.pause, .rewind, .fastForward],
        systemActions: {.seek, .seekBackward, .seekForward},
        androidCompactActionIndices: [0, 2, 1],
        processingState: .loading,
        updatePosition: Duration.zero,
        bufferedPosition: Duration.zero,

        playing: false,
        speed: playbackState.value.speed,
      ),
    );
  }

  void updatePlayerState(PlayerState event) {
    print('new player state: ${event}');
    var playing = switch (event) {
      .playing => true,
      .paused || .stopped => false,
      _ => playbackState.value.playing,
    };
    var newState = playbackState.value.copyWith(
      playing: playing,
      controls: [playing ? .pause : .play, .rewind, .fastForward],
      processingState: switch (event) {
        .playing => .ready,
        .paused => .ready,
        .completed => .completed,
        .disposed => .completed,
        // .ready => .ready,
        // .buffering => .buffering,
        // .idle => .idle,
        _ => playbackState.value.processingState,
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

  @override
  Future<void> setSpeed(double speed) async {
    _player.setPlaybackRate(speed);
    playbackState.add(playbackState.value.copyWith(speed: speed));
  }
}
