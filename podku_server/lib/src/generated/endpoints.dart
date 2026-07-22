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
import 'package:serverpod/serverpod.dart' as _i1;
import '../episodes/episodes_endoint.dart' as _i2;
import '../podcast/podcast_endpoint.dart' as _i3;
import 'package:podku_server/src/generated/podcast/episode.dart' as _i4;
import 'package:podku_server/src/generated/podcast/search_result.dart' as _i5;
import 'package:podku_server/src/generated/podcast/podcast.dart' as _i6;
import 'package:podku_server/src/generated/future_calls.dart' as _i7;
export 'future_calls.dart' show ServerpodFutureCallsGetter;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'episodes': _i2.EpisodesEndpoint()
        ..initialize(
          server,
          'episodes',
          null,
        ),
      'podcast': _i3.PodcastEndpoint()
        ..initialize(
          server,
          'podcast',
          null,
        ),
    };
    connectors['episodes'] = _i1.EndpointConnector(
      name: 'episodes',
      endpoint: endpoints['episodes']!,
      methodConnectors: {
        'getEpisodes': _i1.MethodConnector(
          name: 'getEpisodes',
          params: {
            'after': _i1.ParameterDescription(
              name: 'after',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'pageSize': _i1.ParameterDescription(
              name: 'pageSize',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['episodes'] as _i2.EpisodesEndpoint).getEpisodes(
                    session,
                    after: params['after'],
                    pageSize: params['pageSize'],
                  ),
        ),
        'getEpisode': _i1.MethodConnector(
          name: 'getEpisode',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['episodes'] as _i2.EpisodesEndpoint).getEpisode(
                    session,
                    params['id'],
                  ),
        ),
        'startPlayback': _i1.MethodConnector(
          name: 'startPlayback',
          params: {
            'episode': _i1.ParameterDescription(
              name: 'episode',
              type: _i1.getType<_i4.Episode>(),
              nullable: false,
            ),
            'player': _i1.ParameterDescription(
              name: 'player',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['episodes'] as _i2.EpisodesEndpoint).startPlayback(
                    session,
                    params['episode'],
                    params['player'],
                  ),
        ),
        'setProgress': _i1.MethodConnector(
          name: 'setProgress',
          params: {
            'episode': _i1.ParameterDescription(
              name: 'episode',
              type: _i1.getType<_i4.Episode>(),
              nullable: false,
            ),
            'player': _i1.ParameterDescription(
              name: 'player',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['episodes'] as _i2.EpisodesEndpoint).setProgress(
                    session,
                    params['episode'],
                    params['player'],
                  ),
        ),
        'playbackStream': _i1.MethodStreamConnector(
          name: 'playbackStream',
          params: {
            'player': _i1.ParameterDescription(
              name: 'player',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['episodes'] as _i2.EpisodesEndpoint)
                  .playbackStream(
                    session,
                    params['player'],
                  ),
        ),
      },
    );
    connectors['podcast'] = _i1.EndpointConnector(
      name: 'podcast',
      endpoint: endpoints['podcast']!,
      methodConnectors: {
        'getPodcasts': _i1.MethodConnector(
          name: 'getPodcasts',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['podcast'] as _i3.PodcastEndpoint)
                  .getPodcasts(session),
        ),
        'searchPodcasts': _i1.MethodConnector(
          name: 'searchPodcasts',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['podcast'] as _i3.PodcastEndpoint).searchPodcasts(
                    session,
                    params['query'],
                  ),
        ),
        'subscribeToPodcast': _i1.MethodConnector(
          name: 'subscribeToPodcast',
          params: {
            'result': _i1.ParameterDescription(
              name: 'result',
              type: _i1.getType<_i5.SearchResult>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['podcast'] as _i3.PodcastEndpoint)
                  .subscribeToPodcast(
                    session,
                    params['result'],
                  ),
        ),
        'parsePodcast': _i1.MethodConnector(
          name: 'parsePodcast',
          params: {
            'result': _i1.ParameterDescription(
              name: 'result',
              type: _i1.getType<_i5.SearchResult>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['podcast'] as _i3.PodcastEndpoint).parsePodcast(
                    session,
                    params['result'],
                  ),
        ),
        'unsubscribe': _i1.MethodConnector(
          name: 'unsubscribe',
          params: {
            'podcast': _i1.ParameterDescription(
              name: 'podcast',
              type: _i1.getType<_i6.Podcast>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['podcast'] as _i3.PodcastEndpoint).unsubscribe(
                    session,
                    params['podcast'],
                  ),
        ),
        'getPodcast': _i1.MethodConnector(
          name: 'getPodcast',
          params: {
            'podcastId': _i1.ParameterDescription(
              name: 'podcastId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['podcast'] as _i3.PodcastEndpoint).getPodcast(
                    session,
                    params['podcastId'],
                  ),
        ),
      },
    );
  }

  @override
  _i1.FutureCallDispatch? get futureCalls {
    return _i7.FutureCalls();
  }
}
