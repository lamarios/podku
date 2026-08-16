import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_3_expressive/foundations/m3e_theme.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/episodes/models/person.dart';
import 'package:podku/utils.dart';

const double _imageSize = 100;

class PeopleList extends StatelessWidget {
  final Episode episode;
  final bool wrap;
  final double size;
  final TextStyle? nameStyle;

  const PeopleList({super.key, required this.episode, required this.wrap, this.size = _imageSize, this.nameStyle});

  @override
  Widget build(BuildContext context) {
    if (episode.people == null || episode.people!.isEmpty) {
      return SizedBox.shrink();
    }

    final textTheme = M3ETheme.of(context).textTheme;
    final colors = M3ETheme.of(context).colorScheme;

    List<Widget> children = (episode.people ?? []).map((p) {
      return Column(
        mainAxisSize: .min,
        children: [
          Container(
            width: size,
            height: size,
            clipBehavior: .hardEdge,
            decoration: BoxDecoration(color: colors.secondaryContainer, shape: .circle),
            child: p.image != null
                ? CachedNetworkImage(imageUrl: p.imageUrl, imageRenderMethodForWeb: .HttpGet, cacheKey: p.image)
                : Center(child: Text((p.name ?? '').substring(0, 1))),
          ),
          Text(p.name ?? '', style: nameStyle ?? textTheme.bodyMedium),
          if (p.role != null) Text(p.role!, style: textTheme.labelSmall?.copyWith(color: colors.secondary)),
        ],
      );
    }).toList();

    return wrap
        ? Wrap(spacing: pu2, runSpacing: pu2, children: children)
        : ListView(scrollDirection: .horizontal, children: children);
  }
}
