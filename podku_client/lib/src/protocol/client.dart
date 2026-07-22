/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:podku_client/src/protocol/podcast/episode.dart' as _i3;
import 'package:podku_client/src/protocol/episodes/episode_progress.dart'
    as _i4;
import 'package:podku_client/src/protocol/podcast/podcast.dart' as _i5;
import 'package:podku_client/src/protocol/podcast/search_result.dart' as _i6;
import 'protocol.dart' as _i7;

/// {@category Endpoint}
class EndpointEpisodes extends _i1.EndpointRef {
  EndpointEpisodes(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'episodes';

  _i2.Future<List<_i3.Episode>> getEpisodes({
    int? after,
    required int pageSize,
  }) => caller.callServerEndpoint<List<_i3.Episode>>(
    'episodes',
    'getEpisodes',
    {
      'after': after,
      'pageSize': pageSize,
    },
  );

  _i2.Future<_i3.Episode?> getEpisode(_i1.UuidValue id) =>
      caller.callServerEndpoint<_i3.Episode?>(
        'episodes',
        'getEpisode',
        {'id': id},
      );

  _i2.Future<void> startPlayback(
    _i3.Episode episode,
    _i1.UuidValue player,
  ) => caller.callServerEndpoint<void>(
    'episodes',
    'startPlayback',
    {
      'episode': episode,
      'player': player,
    },
  );

  _i2.Future<void> setProgress(
    _i3.Episode episode,
    _i1.UuidValue player,
  ) => caller.callServerEndpoint<void>(
    'episodes',
    'setProgress',
    {
      'episode': episode,
      'player': player,
    },
  );

  _i2.Stream<_i4.EpisodeProgress> playbackStream(_i1.UuidValue player) =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<_i4.EpisodeProgress>,
        _i4.EpisodeProgress
      >(
        'episodes',
        'playbackStream',
        {'player': player},
        {},
      );
}

/// {@category Endpoint}
class EndpointPodcast extends _i1.EndpointRef {
  EndpointPodcast(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'podcast';

  _i2.Future<List<_i5.Podcast>> getPodcasts() =>
      caller.callServerEndpoint<List<_i5.Podcast>>(
        'podcast',
        'getPodcasts',
        {},
      );

  _i2.Future<List<_i6.SearchResult>> searchPodcasts(String query) =>
      caller.callServerEndpoint<List<_i6.SearchResult>>(
        'podcast',
        'searchPodcasts',
        {'query': query},
      );

  _i2.Future<_i5.Podcast> subscribeToPodcast(_i6.SearchResult result) =>
      caller.callServerEndpoint<_i5.Podcast>(
        'podcast',
        'subscribeToPodcast',
        {'result': result},
      );

  _i2.Future<_i5.Podcast> parsePodcast(_i6.SearchResult result) =>
      caller.callServerEndpoint<_i5.Podcast>(
        'podcast',
        'parsePodcast',
        {'result': result},
      );

  _i2.Future<bool> unsubscribe(_i5.Podcast podcast) =>
      caller.callServerEndpoint<bool>(
        'podcast',
        'unsubscribe',
        {'podcast': podcast},
      );

  _i2.Future<_i5.Podcast?> getPodcast(String podcastId) =>
      caller.callServerEndpoint<_i5.Podcast?>(
        'podcast',
        'getPodcast',
        {'podcastId': podcastId},
      );
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i7.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    episodes = EndpointEpisodes(this);
    podcast = EndpointPodcast(this);
  }

  late final EndpointEpisodes episodes;

  late final EndpointPodcast podcast;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
    'episodes': episodes,
    'podcast': podcast,
  };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {};
}
