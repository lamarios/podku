import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:podku/episodes/views/components/episode_play_button.dart';
import 'package:podku/episodes/views/components/episode_sheet.dart';
import 'package:podku/episodes/views/components/episode_sub_title.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/utils.dart';
import 'package:podku_client/podku_client.dart';

const double _imageSize = 175;

class EpisodeInGrid extends StatelessWidget {
  static const double mainAxisExtent = 250;
  static const double crossAxisExtent = 250;
  static const double crossAxisSpacing = pu4;
  static const double mainAxisSpacing = pu3;

  final Episode episode;
  final bool offline;
  final bool showPodcastImage;

  const EpisodeInGrid({super.key, required this.episode, this.offline = false, this.showPodcastImage = true});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => EpisodeSheet.open(context, episode, offline),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Center(
            child: SizedBox(
              width: _imageSize,
              height: _imageSize,
              child: ClipRRect(
                borderRadius: .circular(pu4),
                child: Stack(
                  alignment: .center,
                  children: [
                    episode.podcast != null && showPodcastImage
                        ? PodcastImage(
                            podcast: episode.podcast!,
                            width: _imageSize,
                            height: _imageSize,
                            borderRadius: pu4,
                          )
                        : Container(
                            width: _imageSize,
                            height: _imageSize,
                            decoration: BoxDecoration(borderRadius: .circular(pu4), color: colors.secondaryContainer),
                            child: Center(
                              child: Icon(
                                Icons.podcasts,
                                size: _imageSize / 3,
                                color: colors.onSecondaryContainer.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        alignment: .bottomRight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],

                            begin: .bottomCenter,
                            end: .topCenter,
                          ),
                        ),
                        child: Padding(
                          padding: .only(right: pu2, bottom: pu2, top: pu6),
                          child: EpisodePlayButton(episode: episode, offline: offline),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Gap(pu2),
          Row(
            crossAxisAlignment: .center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    Text(episode.title, maxLines: 2, overflow: .ellipsis),
                    EpisodeSubTitle(episode: episode, offline: offline),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
