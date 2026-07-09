import 'package:http/http.dart' as http;
import 'package:podku_server/src/generated/podcast/podcast.dart';
import 'package:xml/xml.dart';

import '../generated/podcast/episode.dart';

/// Parses podcast RSS/XML (with iTunes namespace extensions) into a
/// [PodcastFeed].
class PodcastFeedParser {
  static const _itunesNs = 'http://www.itunes.com/dtds/podcast-1.0.dtd';

  static Future<Podcast> parseUrl(Podcast podcast) async {
    final httpClient = http.Client();
    final response = await httpClient.get(Uri.parse(podcast.url));
    if (response.statusCode != 200) {
      throw PodcastFeedException(
        'Failed to fetch feed at ${podcast.url} (status ${response.statusCode})',
      );
    }
    return parse(podcast, response.body);
  }

  /// Parses a raw XML string (fetched from a feed's `feedUrl`).
  static Podcast parse(Podcast podcast, String xmlString) {
    final document = XmlDocument.parse(xmlString);
    final channel = document.findAllElements('channel').first;

    final episodes = channel.findElements('item').map((e) => _parseItem(podcast, e),).toList(growable: false);

    return podcast.copyWith(
      name: _text(channel, 'title') ?? '',
      description: _text(channel, 'description') ?? _itunesText(channel, 'summary'),
      artworkUrl: _channelImage(channel),
      author: _itunesText(channel, 'author'),
      link: _text(channel, 'link'),
      episodes: episodes,
    );
  }

  static Episode _parseItem(Podcast podcast, XmlElement item) {
    final enclosure = item.findElements('enclosure').firstOrNull;

    return Episode(
      title: _text(item, 'title') ?? 'Untitled episode',
      description: _text(item, 'description') ?? _itunesText(item, 'summary'),
      audioUrl: enclosure?.getAttribute('url'),
      audioType: enclosure?.getAttribute('type'),
      audioLengthBytes: int.tryParse(enclosure?.getAttribute('length') ?? ''),
      pubDateMillis: _parseDateMillis(_text(item, 'pubDate')),
      durationSeconds: _parseDurationSeconds(_itunesText(item, 'duration')),
      guid: _text(item, 'guid'),
      imageUrl: _itemImage(item),
      seasonNumber: int.tryParse(_itunesText(item, 'season') ?? ''),
      episodeNumber: int.tryParse(_itunesText(item, 'episode') ?? ''),
      episodeType: _itunesText(item, 'episodeType'),
      explicit: (_itunesText(item, 'explicit') ?? 'false').toLowerCase() == 'true' || (_itunesText(item, 'explicit') ?? '').toLowerCase() == 'yes',
      link: _text(item, 'link'),
      podcastId: podcast.id
    );
  }

  // --- helpers ------------------------------------------------------

  static String? _text(XmlElement parent, String tag) {
    return parent.findElements(tag).firstOrNull?.innerText.trim();
  }

  /// Reads a tag from the `itunes:` namespace, e.g. <itunes:duration>.
  static String? _itunesText(XmlElement parent, String tag) {
    final el = parent.findElements(tag, namespace: _itunesNs).firstOrNull;
    return el?.innerText.trim();
  }

  static String? _channelImage(XmlElement channel) {
    final itunesImage = channel.findElements('image', namespace: _itunesNs).firstOrNull?.getAttribute('href');
    if (itunesImage != null) return itunesImage;

    final rssImage = channel.findElements('image').firstOrNull;
    return rssImage?.findElements('url').firstOrNull?.innerText.trim();
  }

  static String? _itemImage(XmlElement item) {
    return item.findElements('image', namespace: _itunesNs).firstOrNull?.getAttribute('href');
  }

  static const _monthsByAbbr = {
    'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6,
    'jul': 7, 'aug': 8, 'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12,
  };

  static const _namedTimezoneOffsetMinutes = {
    'UT': 0, 'GMT': 0, 'UTC': 0, 'Z': 0,
    'EST': -300, 'EDT': -240,
    'CST': -360, 'CDT': -300,
    'MST': -420, 'MDT': -360,
    'PST': -480, 'PDT': -420,
  };

  /// Parses an RSS `pubDate` (RFC 822/2822, e.g.
  /// "Wed, 02 Oct 2024 15:00:00 +0000" or "02 Oct 2024 15:00:00 GMT")
  /// into epoch milliseconds.
  ///
  /// dart:io's `HttpDate.parse` looks like a fit for this but isn't: it only
  /// accepts the literal "GMT" timezone in a fixed RFC 1123 layout, so it
  /// throws on the "+0000"/named-timezone variants almost every real feed
  /// uses — and `DateTime.tryParse` only understands ISO 8601, not this
  /// format either. Hence a hand-rolled parser.
  static int? _parseDateMillis(String? raw) {
    if (raw == null || raw.isEmpty) return null;

    var s = raw.trim();
    // Strip an optional leading day-of-week, e.g. "Wed, 02 Oct ...".
    final commaIndex = s.indexOf(',');
    if (commaIndex != -1) {
      s = s.substring(commaIndex + 1).trim();
    }

    final parts = s.split(RegExp(r'\s+'));
    if (parts.length < 4) return null;

    final day = int.tryParse(parts[0]);
    final month = _monthsByAbbr[parts[1].toLowerCase().substring(
        0, parts[1].length >= 3 ? 3 : parts[1].length)];
    var year = int.tryParse(parts[2]);
    final timeParts =
    parts[3].split(':').map((p) => int.tryParse(p)).toList();

    if (day == null ||
        month == null ||
        year == null ||
        timeParts.length < 2 ||
        timeParts.any((p) => p == null)) {
      return null;
    }

    // Handle 2-digit years per RFC 2822 pivoting rules.
    if (year < 100) year += year < 70 ? 2000 : 1900;

    final hour = timeParts[0]!;
    final minute = timeParts[1]!;
    final second = timeParts.length > 2 ? timeParts[2]! : 0;

    final offsetMinutes =
    parts.length > 4 ? _parseTimezoneOffsetMinutes(parts[4]) : 0;

    try {
      final utc = DateTime.utc(year, month, day, hour, minute, second)
          .subtract(Duration(minutes: offsetMinutes));
      return utc.millisecondsSinceEpoch;
    } catch (_) {
      return null;
    }
  }
  static int _parseTimezoneOffsetMinutes(String tz) {
    if (tz.startsWith('+') || tz.startsWith('-')) {
      final sign = tz.startsWith('-') ? -1 : 1;
      final digits = tz.substring(1);
      if (digits.length == 4) {
        final hours = int.tryParse(digits.substring(0, 2)) ?? 0;
        final minutes = int.tryParse(digits.substring(2, 4)) ?? 0;
        return sign * (hours * 60 + minutes);
      }
    }
    return _namedTimezoneOffsetMinutes[tz.toUpperCase()] ?? 0;
  }

  /// iTunes duration can be plain seconds ("1425") or HH:MM:SS / MM:SS.
  /// Returns the total duration in seconds.
  static int? _parseDurationSeconds(String? raw) {
    if (raw == null || raw.isEmpty) return null;

    if (!raw.contains(':')) {
      return int.tryParse(raw);
    }

    final parts = raw.split(':').map((p) => int.tryParse(p) ?? 0).toList();
    if (parts.length == 3) {
      return parts[0] * 3600 + parts[1] * 60 + parts[2];
    } else if (parts.length == 2) {
      return parts[0] * 60 + parts[1];
    }
    return null;
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

class PodcastFeedException implements Exception {
  final String message;

  PodcastFeedException(this.message);

  @override
  String toString() => 'PodcastFeedException: $message';
}
