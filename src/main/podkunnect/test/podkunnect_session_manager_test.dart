import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:openapi/openapi.dart';
import 'package:podkunnect/podkunnect.dart';
import 'package:test/test.dart';

import 'mocks/mock_player.dart';

/// Simulates the WebSocket and HTTP endpoints of WebSocketSessionManager.java
class MockWebSocketSessionManagerServer {
  late final HttpServer _server;
  final List<WebSocket> _connectedSockets = [];
  final StreamController<Map<String, dynamic>> _receivedMessagesController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get receivedMessages => _receivedMessagesController.stream;

  int get port => _server.port;
  String get url => 'http://127.0.0.1:$port';

  Future<void> start() async {
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _server.listen((HttpRequest request) async {
      if (request.uri.path == '/ws') {
        if (WebSocketTransformer.isUpgradeRequest(request)) {
          final socket = await WebSocketTransformer.upgrade(request);
          _connectedSockets.add(socket);
          socket.listen(
            (data) {
              if (data == 'ping') {
                // Ignore raw websocket ping
                return;
              }
              try {
                final json = jsonDecode(data as String) as Map<String, dynamic>;
                _receivedMessagesController.add(json);
              } catch (e) {
                // ignore parsing failures
              }
            },
            onDone: () {
              _connectedSockets.remove(socket);
            },
          );
        } else {
          request.response.statusCode = HttpStatus.badRequest;
          await request.response.close();
        }
      } else if (request.uri.path.startsWith('/media/audio/')) {
        // Return valid MP3 frame bytes
        request.response.headers.contentType = ContentType('audio', 'mpeg');
        request.response.headers.contentLength = 5;
        request.response.add([0xFF, 0xFB, 0x90, 0x64, 0x00]);
        await request.response.close();
      } else if (request.uri.path.startsWith('/api/episodes/')) {
        // Return mock episode JSON
        final episode = Episode(
          id: 'mock-ep-1',
          title: 'Mocked Server Episode',
          durationSeconds: 120,
          progress: 10,
          audioUrlEncrypted: 'mock-encrypted-audio',
        );
        request.response.headers.contentType = ContentType.json;
        request.response.write(jsonEncode(episode.toJson()));
        await request.response.close();
      } else {
        request.response.statusCode = HttpStatus.notFound;
        await request.response.close();
      }
    });
  }

  void broadcast(Map<String, dynamic> message) {
    final encoded = jsonEncode(message);
    for (final socket in _connectedSockets) {
      socket.add(encoded);
    }
  }

  void sendRawPing() {
    for (final socket in _connectedSockets) {
      socket.add('ping');
    }
  }

  Future<void> stop() async {
    for (final socket in _connectedSockets) {
      await socket.close();
    }
    await _server.close(force: true);
    await _receivedMessagesController.close();
  }
}

void main() {
  group('WebSocketSessionManager client integration tests', () {
    late MockWebSocketSessionManagerServer mockServer;

    setUp(() async {
      mockServer = MockWebSocketSessionManagerServer();
      await mockServer.start();
    });

    tearDown(() async {
      await mockServer.stop();
    });

    test('performs initial handshake by sending playerInfo on connection', () async {
      final receivedFuture = mockServer.receivedMessages.firstWhere((msg) => msg['type'] == 'playerInfo');

      final client = Podkunnect(id: 'device-test-handshake', name: 'Stereo Player', serverUrl: mockServer.url);

      final received = await receivedFuture.timeout(const Duration(seconds: 5));
      expect(received['type'], equals('playerInfo'));

      final message = received['message'] as Map<String, dynamic>;
      expect(message['id'], equals('device-test-handshake'));
      expect(message['name'], equals('Stereo Player'));

      await client.dispose();
    });

    test('replies with pong status when server broadcasts clientList', () async {
      final pongFuture = mockServer.receivedMessages.firstWhere((msg) => msg['type'] == 'pong');

      final client = Podkunnect(id: 'device-test-pingpong', name: 'Desk Player', serverUrl: mockServer.url);

      // Wait for playerInfo first
      await mockServer.receivedMessages.firstWhere((msg) => msg['type'] == 'playerInfo');

      // Server broadcasts clientList (as in WebSocketSessionManager.java pingSessions())
      mockServer.broadcast({
        'type': 'clientList',
        'message': {
          'currentPlayer': null,
          'clients': [
            {'id': 'device-test-pingpong', 'name': 'Desk Player'},
          ],
        },
      });

      final pongMessage = await pongFuture.timeout(const Duration(seconds: 5));
      expect(pongMessage['type'], equals('pong'));

      final status = pongMessage['message'] as Map<String, dynamic>;
      expect(status['episode'], isNull);
      expect(status['position'], equals(0));
      expect(status['duration'], equals(0));

      await client.dispose();
    });

    test('starts playback and broadcasts playerStatus on transferPlayback', () async {
      final client = Podkunnect(
        id: 'device-test-playback',
        name: 'Kitchen Node',
        serverUrl: mockServer.url,
        playerFactory: () => createMockPlayer(),
      );

      // Wait for registration
      await mockServer.receivedMessages.firstWhere((msg) => msg['type'] == 'playerInfo');

      final statusFuture = mockServer.receivedMessages.firstWhere((msg) => msg['type'] == 'playerStatus');

      final episode = Episode(
        id: 'ep-abc',
        title: 'Morning News',
        durationSeconds: 180,
        audioUrlEncrypted: 'mock-audio-hash',
      );

      // Server transfers playback to this device
      mockServer.broadcast({
        'type': 'transferPlayback',
        'message': {'playerId': 'device-test-playback', 'position': 15, 'episode': episode.toJson()},
      });

      final statusMessage = await statusFuture.timeout(const Duration(seconds: 5));
      expect(statusMessage['type'], equals('playerStatus'));

      final status = statusMessage['message'] as Map<String, dynamic>;
      expect(status['playing'], isTrue);
      expect(status['position'], equals(15));
      expect(status['episode']['title'], equals('Morning News'));

      await client.dispose();
    });

    test('stops playback when transferPlayback targets a different playerId', () async {
      final client = Podkunnect(
        id: 'device-test-stop',
        name: 'Bedroom Node',
        serverUrl: mockServer.url,
        playerFactory: () => createMockPlayer(),
      );

      await mockServer.receivedMessages.firstWhere((msg) => msg['type'] == 'playerInfo');

      // Start playback first
      final episode = Episode(
        id: 'ep-def',
        title: 'Night Podcast',
        durationSeconds: 300,
        audioUrlEncrypted: 'mock-audio-hash-2',
      );

      await client.startPlayback(episode: episode, position: 0);
      expect(client.player, isNotNull);

      // Server transfers playback to another device
      mockServer.broadcast({
        'type': 'transferPlayback',
        'message': {'playerId': 'someone-elses-device', 'position': 50, 'episode': episode.toJson()},
      });

      // Small wait for async dispatch
      await Future.delayed(const Duration(milliseconds: 200));

      expect(client.player, isNull);

      await client.dispose();
    });

    test('handles remoteCommand speed and volume from server', () async {
      final client = Podkunnect(
        id: 'device-test-commands',
        name: 'Control Node',
        serverUrl: mockServer.url,
        playerFactory: () => createMockPlayer(),
      );

      await mockServer.receivedMessages.firstWhere((msg) => msg['type'] == 'playerInfo');

      // Start playback so player is active
      final episode = Episode(
        id: 'ep-ctrl',
        title: 'Control Test',
        durationSeconds: 60,
        audioUrlEncrypted: 'mock-audio-hash-3',
      );
      await client.startPlayback(episode: episode, position: 0);

      // Expect playerStatus update with volume 65
      var statusFuture = mockServer.receivedMessages.firstWhere(
        (msg) => msg['type'] == 'playerStatus' && msg['message']?['volume'] == 65.0,
      );

      // Send remoteCommand setVolume
      mockServer.broadcast({
        'type': 'remoteCommand',
        'message': {'type': 'setVolume', 'volume': 65.0},
      });

      var updated = await statusFuture.timeout(const Duration(seconds: 5));
      expect(updated['type'], equals('playerStatus'));
      expect(client.player?.state.volume, equals(65.0));

      statusFuture = mockServer.receivedMessages.firstWhere(
        (msg) => msg['type'] == 'playerStatus' && msg['message']?['speed'] == 1.75,
      );

      // Send remoteCommand setSpeed
      mockServer.broadcast({
        'type': 'remoteCommand',
        'message': {'type': 'setSpeed', 'speed': 1.75},
      });

      updated = await statusFuture.timeout(const Duration(seconds: 5));
      expect(updated['type'], equals('playerStatus'));
      expect(client.player?.state.rate, equals(1.75));

      await client.dispose();
    });

    test('tolerates raw ping messages from WebSocketSessionManager without error', () async {
      final client = Podkunnect(id: 'device-test-raw-ping', name: 'Ping Test Node', serverUrl: mockServer.url);

      await mockServer.receivedMessages.firstWhere((msg) => msg['type'] == 'playerInfo');

      // Send raw "ping" text as sent by WebSocketSessionManager.java line 136:
      // s.sendMessage(new TextMessage("ping"));
      mockServer.sendRawPing();

      await Future.delayed(const Duration(milliseconds: 100));

      expect(client.socket?.isConnected, isTrue);

      await client.dispose();
    });
  });
}
