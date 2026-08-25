import 'dart:async';

final StreamController<AppAction> actionStream = StreamController.broadcast();

enum AppAction { refreshEpisodes, refreshPodcasts, refreshBookmarks }
