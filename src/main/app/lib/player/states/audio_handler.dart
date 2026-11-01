import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:logging/logging.dart';
import 'package:media_kit/media_kit.dart' as mk;
import 'package:media_kit_video/media_kit_video.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/episodes/models/episode_downloads.dart';
import 'package:podku/episodes/models/episode_url.dart';
import 'package:podku/main.dart';
import 'package:podku/offline_episodes/states/download_manager.dart';
import 'package:podku/podcasts/models/podcast.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/android_file_provider.dart';

const _autoMain = 'main';
const _autoEpisodes = 'episodes';
const _autoPodcast = 'podcast-';
const _autoOfflineList = 'offline';
const _autoOffline = 'offline-';

/// Plays episodes with two engines: just_audio for listening (background playback, audio focus, interruptions) and
/// media_kit for watching videos, only used while the video is on screen. Only one engine is active at a time, the
/// playback controls and the reported playback state follow the active one.
class PodkuAudioHandler extends BaseAudioHandler with SeekHandler {
  static final _log = Logger('PodkuAudioHandler');
  final _player = AudioPlayer();
  final StreamController<Duration> durationStream = StreamController.broadcast();

  mk.Player? _videoPlayer;
  VideoController? _videoController;
  bool _videoActive = false;
  String? _videoUrl;

  // switching engines is asynchronous, switches are chained so they never interleave
  Future<void> _videoSwitch = Future.value();

  /// Whether the episode is currently played as a video.
  bool get videoActive => _videoActive;

  /// Controller rendering the video, set once a video has been played.
  VideoController? get videoController => _videoController;

  PodkuAudioHandler() {
    init();
  }

  void init() {
    // events of the audio player are ignored while the video player is active, e.g. the audio pausing when the video
    // takes over
    _player.playerStateStream.listen((event) {
      if (!_videoActive) updatePlayerState(event);
    });
    // _player.bufferedPositionStream.listen(updateBuffering);
    _player.positionStream.listen((event) {
      if (!_videoActive) updatePosition(event);
    });
    _player.durationStream.listen((event) {
      if (!_videoActive) updateDuration(event);
    });
  }

  mk.Player get _video {
    var video = _videoPlayer;
    if (video == null) {
      video = mk.Player();
      _videoController = VideoController(
        video,
        configuration: !kIsWeb && Platform.isAndroid && kDebugMode
            ? const VideoControllerConfiguration(vo: 'mediacodec_embed', hwdec: 'mediacodec')
            : const VideoControllerConfiguration(),
      );
      video.stream.playing.listen((_) => _updateVideoState());
      video.stream.completed.listen((_) => _updateVideoState());
      video.stream.buffering.listen((_) => _updateVideoState());
      video.stream.position.listen((event) {
        // the position is reported as zero until the media is loaded and seeked to its start position
        if (_videoActive && video!.state.duration > Duration.zero) updatePosition(event);
      });
      video.stream.duration.listen((event) {
        if (_videoActive && event > Duration.zero) updateDuration(event);
      });
      video.stream.error.listen((event) => _log.warning('Video player error: $event'));
      _videoPlayer = video;
    }
    return video;
  }

  Duration get _position => _videoActive ? _video.state.position : _player.position;

  /// Watches the episode: hands the playback over from the audio player to the video player, at the same position.
  ///
  /// [url] is the video URL of the episode currently loaded in the audio player.
  Future<void> showVideo(String url) => _switchEngine(() async {
    if (_videoActive && _videoUrl == url) {
      return;
    }
    final position = _player.position;
    final playing = _player.playing;
    _log.fine('Switching to video at $position, playing: $playing');

    _videoActive = true;
    _videoUrl = url;
    await _player.pause();
    try {
      final video = _video;
      await video.setRate(_player.speed);
      await video.setVolume(_player.volume * 100);
      await video.open(mk.Media(url, start: position), play: playing);
    } catch (e, s) {
      _log.severe('Failed to play video, going back to audio', e, s);
      _videoActive = false;
      _videoUrl = null;
      if (playing) _player.play();
    }
  });

  /// Listens to the episode: hands the playback over from the video player back to the audio player, at the same
  /// position.
  Future<void> showAudio() => _switchEngine(() async {
    if (!_videoActive) {
      return;
    }
    final video = _video;
    final position = video.state.position;
    final playing = video.state.playing;
    _log.fine('Switching to audio at $position, playing: $playing');

    _videoActive = false;
    _videoUrl = null;
    await video.stop();
    await _player.seek(position);
    playbackState.add(playbackState.value.copyWith(updatePosition: position));
    if (playing) {
      // not awaited, just_audio's play only completes once the playback is paused
      _player.play();
    }
  });

  Future<void> _switchEngine(Future<void> Function() switchEngine) {
    return _videoSwitch = _videoSwitch.then((_) => switchEngine()).catchError((Object e, StackTrace s) {
      _log.severe('Failed to switch player', e, s);
    });
  }

  void _updateVideoState() {
    if (!_videoActive) {
      return;
    }
    final state = _video.state;
    playbackState.add(
      playbackState.value.copyWith(
        playing: state.playing,
        controls: [state.playing ? .pause : .play, .rewind, .fastForward],
        processingState: state.completed
            ? .completed
            : state.buffering
            ? .buffering
            : .ready,
      ),
    );
  }

  /// Stops the video player, without resuming the audio.
  Future<void> _stopVideo() async {
    if (_videoActive) {
      _videoActive = false;
      _videoUrl = null;
      await _videoPlayer?.stop();
    }
  }

  @override
  Future<void> play() async {
    _log.fine('play');
    if (_videoActive) {
      await _video.play();
    } else {
      _player.play();
    }
  }

  @override
  Future<void> pause() async {
    _log.fine('Pause');
    if (_videoActive) {
      await _video.pause();
    } else {
      _player.pause();
    }
  }

  @override
  Future<void> stop() async {
    _log.fine('stop');
    await _switchEngine(_stopVideo);
    _player.stop();
    playbackState.add(playbackState.value.copyWith(playing: false, processingState: .completed));
  }

  @override
  Future<void> skipToNext() {
    return fastForward();
  }

  @override
  Future<void> skipToPrevious() {
    return rewind();
  }

  /// volume: 0 - 100
  Future<void> setVolume(double volume) async {
    await _videoPlayer?.setVolume(volume);
    return _player.setVolume((volume / 100));
  }

  double getVolume() {
    return _player.volume;
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
        final podcasts = await client.podcasts.getPodcasts().then((value) => value.data ?? []);
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
      final episodes = await client.episodes.getEpisodes(pageSize: 100).then((value) => value.data ?? []);

      for (final episode in episodes) {
        items.add(await _episodeForAndroidAuto(episode));
      }
    } else if (parentMediaId.startsWith(_autoPodcast)) {
      final podcast = await client.podcasts
          .getPodcast(id: parentMediaId.replaceFirst(_autoPodcast, ''))
          .then((value) => value.data);

      if (podcast != null) {
        for (var e in (podcast.episodes ?? []).take(100)) {
          items.add(await _episodeForAndroidAuto(e.copyWith(podcast: podcast.light)));
        }
      }
    } else if (parentMediaId.startsWith(_autoOfflineList)) {
      final episodes = getIt.get<DownloadManagerCubit>().state.offlineEpisodes;

      for (final e in episodes) {
        final media = (await _episodeForAndroidAuto(e)).copyWith(id: '$_autoOffline${e.id}');
        items.add(media);
      }
    }
    return items; // no deeper nesting needed
  }

  Future<MediaItem> _episodeForAndroidAuto(Episode episode, {bool offline = false}) async {
    return MediaItem(
      id: episode.id ?? '',
      title: episode.title ?? '',
      artist: episode.podcast?.name,
      duration: Duration(seconds: episode.durationSeconds ?? 1),
      playable: true,
      artUri: await getImageContentUri(episode, offline: offline),

      extras: {
        // Completion status — key AND value are different from what I said earlier
        'android.media.extra.PLAYBACK_STATUS': (episode.progress ?? 0) > 0.95
            ? 2 // DESCRIPTION_EXTRAS_VALUE_COMPLETION_STATUS_FULLY_PLAYED
            : (episode.progress ?? 0) > 0
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
          .where((element) => element.id == mediaId.replaceFirst(_autoOffline, ''))
          .firstOrNull;
    } else {
      episode = await client.episodes.getEpisode(id: mediaId).then((value) => value.data);
    }
    if (episode != null) {
      await playEpisode(episode);
      await play();
    }
  }

  @override
  Future<void> seek(Duration position) async {
    if (position.isNegative) {
      return;
    }
    _seek(position);
    playbackState.add(playbackState.value.copyWith(updatePosition: position));
  }

  @override
  Future<void> fastForward() async {
    var position = _position + Duration(seconds: 30);
    _seek(position);

    playbackState.add(playbackState.value.copyWith(updatePosition: position));
  }

  @override
  Future<void> rewind() async {
    var position = _position + Duration(seconds: -10);
    _seek(position);
    playbackState.add(playbackState.value.copyWith(updatePosition: position));
  }

  void _seek(Duration position) {
    if (_videoActive) {
      _video.seek(position);
    } else {
      _player.seek(position);
    }
  }

  Future<void> playEpisode(Episode episode, {Duration? initialPosition, bool offline = false}) async {
    playbackState.add(playbackState.value.copyWith(processingState: .loading));
    // a new episode always starts on the audio player, the video is shown on demand
    await _switchEngine(_stopVideo);

    // we should try to get the latest version of the episode for up to date progress
    if (!offline) {
      try {
        episode = await client.episodes.getEpisode(id: episode.id ?? '').then((value) => value.data) ?? episode;
      } catch (e) {
        _log.warning("Couldn't get the episode before playing, we're probably offline");
      }
    }

    var offlineFiles = kIsWeb ? [] : await episode.offlineFiles;

    String? offlineFile = offlineFiles.where((s) => s.endsWith(episode.episodeFile)).firstOrNull;

    final artUri = await getImageContentUri(episode, offline: offline);

    var audioProxyUrl = episode.audioProxyUrl;

    _log.fine(
      "Episode: ${episode.title}, initial position: $initialPosition, episode duration ${episode.durationSeconds}, episode progress: ${episode.progress}",
    );
    initialPosition ??= episode.durationSeconds == null
        ? Duration.zero
        : Duration(seconds: (episode.progress ?? 0).floor());
    _log.fine("Playing episode starting at $initialPosition");

    durationStream.add(Duration(seconds: episode.durationSeconds ?? 1));

    if (offlineFile != null) {
      _log.fine('playing from offline file');
      await _player.setFilePath(offlineFile, initialPosition: initialPosition);
    } else {
      _log.fine('playing online');
      await _player.setUrl(audioProxyUrl, initialPosition: initialPosition);
    }

    final item = MediaItem(
      id: episode.id ?? '',
      title: episode.title ?? '',
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

  Future<Uri?> getImageContentUri(Episode episode, {bool offline = false}) async {
    if (kIsWeb) {
      return episode.podcast?.artUri;
    }
    var offlineFiles = kIsWeb ? [] : await episode.offlineFiles;

    String? imageFile = offlineFiles.where((n) => n.endsWith(episode.imageFile)).firstOrNull;

    if (!offline && imageFile == null) {
      // downloading the image
      if (episode.podcast?.artUri != null) {
        var image = await episode.podcast?.imageFile;
        if (image != null && !(await image.exists())) {
          final imageResponse = await http.get(episode.podcast!.artUri);
          await image.writeAsBytes(imageResponse.bodyBytes);
        }

        imageFile = image?.path;
      }
    }
    return imageFile == null ? null : await AndroidFileProvider.getContentUriForFile(imageFile);
  }

  void updatePlayerState(PlayerState event) {
    print('new player state: ${event}');
    var playing = event.playing;

    var newState = playbackState.value.copyWith(
      playing: playing,
      controls: [playing ? .pause : .play, .rewind, .fastForward],
      processingState: switch (event.processingState) {
        .completed => .completed,
        .ready => .ready,
        .buffering => .buffering,
        .idle => .idle,
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
    _player.setSpeed(speed);
    _videoPlayer?.setRate(speed);
    playbackState.add(playbackState.value.copyWith(speed: speed));
  }

  void updateDuration(Duration? event) {
    if (event != null) {
      durationStream.add(event);
    }
  }
}
