import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:podku/player/views/components/timestamp_link.dart';
import 'package:podku_client/podku_client.dart';
import 'package:url_launcher/url_launcher.dart';

class HtmlDescription extends StatelessWidget {
  static final _timestampRegex = RegExp(r'\b\d{2}:\d{2}:\d{2}\b');
  final Episode? episode;
  final Podcast? podcast;
  final bool offline;

  const HtmlDescription({super.key, this.episode, this.podcast, required this.offline})
    : assert(episode == null || podcast == null);

  String _tagTimeStamps(String text) {
    if (!text.contains('<br')) {
      text = text.replaceAll('\n', '<br />');
    }
    return _autoLinkUrls(text.replaceAllMapped(_timestampRegex, (match) => '<time>${match.group(0)}</time>'));
  }

  String _autoLinkUrls(String html) {
    // Matches (in order of priority):
    // 1. Existing <a ...>...</a> tags — leave untouched
    // 2. Any HTML tag (so we don't touch URLs inside href="", src="", etc.)
    // 3. Bare URLs — these get wrapped
    final regex = RegExp(
      r'(<a\b[^>]*>.*?</a>)' // group 1: existing <a> tags
      r'|(<[^>]+>)' // group 2: any other tag (e.g. <img src="...">)
      r'|((https?://|www\.)[^\s<]+)', // group 3: bare URL
      caseSensitive: false,
      dotAll: true,
    );

    return html.replaceAllMapped(regex, (match) {
      if (match.group(1) != null) {
        return match.group(1)!; // existing <a> tag, leave as-is
      }
      if (match.group(2) != null) {
        return match.group(2)!; // other tag, leave as-is
      }
      final url = match.group(3)!;
      final href = url.startsWith('www.') ? 'https://$url' : url;
      return '<a href="$href">$url</a>';
    });
  }

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      _tagTimeStamps(episode?.description ?? podcast?.description ?? ''),
      onTapUrl: (url) => launchUrl(Uri.parse(url)),
      customWidgetBuilder: (element) {
        if (episode != null && element.localName == 'time') {
          return InlineCustomWidget(
            child: TimestampLink(episode: episode!, timestamp: element.text, offline: offline),
          );
        }
        return null;
      },
    );
  }
}
