import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:motor/motor.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/breakpoint.dart';
import 'package:podku/utils/views/components/fade_in_text.dart';

final _log = Logger('Past5MinutesSummary');

class Past5MinuteSummary extends StatelessWidget {
  final String episodeId;
  final String language;
  final int time;

  const Past5MinuteSummary({super.key, required this.episodeId, required this.language, required this.time});

  Stream<String> streamTopic(BuildContext context) async* {
    final baseUrl = context.read<ServerCubit>().state.apiUrl;
    final client = http.Client();
    try {
      final url = '$baseUrl/transcripts/$episodeId/$language/summary-until/$time';

      final request = http.Request('GET', Uri.parse(url))..headers['Accept'] = 'text/event-stream';

      _log.fine('Calling $url');

      final response = await client.send(request);
      _log.fine('Status: ${response.statusCode}');
      if (response.statusCode != 200) {
        throw Exception('Stream failed: ${response.statusCode}');
      }

      final buffer = StringBuffer();
      await for (final token
          in response.stream
              .transform(utf8.decoder)
              .transform(const LineSplitter())
              .where((line) => line.startsWith('data:'))
              .map((line) => line.substring(5))) {
        buffer.write(token);
        yield buffer.toString();
      }
    } finally {
      client.close();
    }
  }

  static Future<Object?> open(
    BuildContext context, {
    required String episodeId,
    required String language,
    required int time,
  }) async {
    final isMobile = BreakPoint.of(context) == .mobile;
    final locals = AppLocalizations.of(context)!;
    return isMobile
        ? M3EBottomSheet.show(
            context,
            showDragHandle: false,
            builder: (context) => SafeArea(
              top: false,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.7),
                child: Past5MinuteSummary(episodeId: episodeId, language: language, time: time),
              ),
            ),
          )
        : M3EDialog.show(
            context,
            dialog: M3EDialog(
              // backgroundColor: Colors.transparent,
              // constraints: BoxConstraints(maxWidth: 400, maxHeight: 700),
              icon: Icon(M3EIcons.auto_awesome),
              content: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.6),
                child: Past5MinuteSummary(episodeId: episodeId, language: language, time: time),
              ),
              title: locals.past5MinutesSummary,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: .all(pu8),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 500),
        child: StreamBuilder(
          stream: streamTopic(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      alignment: Alignment.topCenter,
                      child: FadeInText(snapshot.data!, style: textTheme.bodyLarge),
                    ),
                    Align(
                      alignment: .centerLeft,
                      child: SingleMotionBuilder(
                        value: snapshot.connectionState == .done ? 0 : 1,
                        motion: MaterialSpringMotion.expressiveEffectsSlow(),
                        builder: (context, value, child) => Opacity(
                          opacity: value.clamp(0, 1),
                          child: Transform.scale(scale: value.clamp(0, 1), child: child),
                        ),
                        child: SizedBox(width: 25, height: 25, child: LoadingIndicator()),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return SizedBox(width: 50, height: 50, child: LoadingIndicator());
            }
          },
        ),
      ),
    );
  }
}
