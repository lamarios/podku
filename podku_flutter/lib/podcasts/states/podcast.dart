import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:podku_client/podku_client.dart';
import 'package:podku_flutter/main.dart';
import 'package:podku_flutter/podcasts/states/podcasts.dart';

part 'podcast.freezed.dart';

class PodcastCubit extends Cubit<PodcastState>{
  final String podcastId;

  PodcastCubit(super.initialState, {required this.podcastId}){
    getPodcast();
  }


  Future<void> getPodcast() async {
   final podcast = await client.podcast.getPodcast(podcastId);
   emit(state.copyWith(podcast: podcast, loading: false));
  }
}

@freezed
sealed class PodcastState with _$PodcastState {
  const factory PodcastState({
    Podcast? podcast,
    @Default(true) bool loading,
  }) = _PodcastState;
}
