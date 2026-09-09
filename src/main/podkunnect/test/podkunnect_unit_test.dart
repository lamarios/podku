import 'dart:convert';

import 'package:openapi/openapi.dart';
import 'package:podku_shared/podku_shared.dart';
import 'package:podkunnect/podkunnect.dart';
import 'package:test/test.dart';

import 'mocks/mock_player.dart';

class FakeReconnectableWebSocket extends ReconnectableWebSocket {
  final List<PodkuSocketMessage> sentMessages = [];
  final List<String> rawSentStrings = [];
  bool connected = false;

  FakeReconnectableWebSocket({Uri? uri}) : super(uri: uri ?? Uri.parse('ws://localhost:8080/ws'));

  @override
  bool get isConnected => connected;

  @override
  Future<void> connect() async {
    connected = true;
    onConnected?.call();
  }

  @override
  void send(String message) {
    rawSentStrings.add(message);
    try {
      final decoded = jsonDecode(message) as Map<String, dynamic>;
      sentMessages.add(PodkuSocketMessage.fromJson(decoded));
    } catch (_) {
      // Non-JSON messages (e.g. ping)
    }
  }

  @override
  Future<void> close() async {
    connected = false;
    onDisconnected?.call();
  }

  void simulateIncomingMessage(PodkuSocketMessage message) {
    controller.add(message);
  }
}

void main() {
  group('Podkunnect client lifecycle & WebSocket handshake', () {
    late FakeReconnectableWebSocket fakeSocket;
    late Podkunnect podkunnect;

    setUp(() {
      fakeSocket = FakeReconnectableWebSocket();
      podkunnect = Podkunnect(
        id: 'test-node-1',
        name: 'Living Room Speaker',
        serverUrl: 'http://localhost:8080',
        volume: 75.0,
        socket: fakeSocket,
        autoConnect: false,
      );
    });

    tearDown(() async {
      await podkunnect.dispose();
    });

    test('initial state matches constructor arguments', () {
      expect(podkunnect.id, equals('test-node-1'));
      expect(podkunnect.name, equals('Living Room Speaker'));
      expect(podkunnect.serverUrl, equals('http://localhost:8080'));
      expect(podkunnect.volume, equals(75.0));
      expect(podkunnect.playbackStatus, isNull);
    });

    test('connect sends playerInfo to WebSocketSessionManager on connection', () async {
      await podkunnect.connect();

      expect(fakeSocket.isConnected, isTrue);
      expect(fakeSocket.sentMessages, hasLength(1));

      final firstMessage = fakeSocket.sentMessages.first;
      expect(firstMessage.type, equals(PodkuSocketMessageType.playerInfo));

      final playerInfo = PlayerInfo.fromJson(firstMessage.message!);
      expect(playerInfo.id, equals('test-node-1'));
      expect(playerInfo.name, equals('Living Room Speaker'));
    });

    test('dispose cancels subscriptions and disconnects socket', () async {
      await podkunnect.connect();
      expect(fakeSocket.isConnected, isTrue);

      await podkunnect.dispose();
      expect(fakeSocket.isConnected, isFalse);
    });
  });

  group('WebSocketSessionManager message handling', () {
    late FakeReconnectableWebSocket fakeSocket;
    late Podkunnect podkunnect;

    setUp(() async {
      fakeSocket = FakeReconnectableWebSocket();
      podkunnect = Podkunnect(
        id: 'test-node-2',
        name: 'Office Speaker',
        serverUrl: 'http://localhost:8080',
        volume: 80.0,
        socket: fakeSocket,
        autoConnect: false,
      );
      await podkunnect.connect();
      // Clear the playerInfo handshake message to make message assertions clean
      fakeSocket.sentMessages.clear();
    });

    tearDown(() async {
      await podkunnect.dispose();
    });

    test('responds to clientList with pong containing idle player status', () async {
      // In WebSocketSessionManager.java: pingSessions() sends clientList
      final clientListMsg = PodkuSocketMessage(
        message: ClientList(
          currentPlayer: null,
          clients: [PlayerInfo(id: 'test-node-2', name: 'Office Speaker')],
        ).toJson(),
        type: PodkuSocketMessageType.clientList,
      );

      await podkunnect.handleSocketMessage(clientListMsg);

      expect(fakeSocket.sentMessages, hasLength(1));
      final response = fakeSocket.sentMessages.first;
      expect(response.type, equals(PodkuSocketMessageType.pong));

      final pongStatus = PlayerStatus.fromJson(response.message!);
      expect(pongStatus.episode, isNull);
      expect(pongStatus.position, equals(0));
      expect(pongStatus.duration, equals(0));
      expect(pongStatus.speed, equals(1.0));
    });

    test('responds to clientList with active status when playback is active', () async {
      final episode = Episode(id: 'ep-001', title: 'Episode 1', durationSeconds: 3600, audioUrlEncrypted: 'hash001');

      podkunnect.playbackStatus = PlayerStatus(
        episode: episode,
        position: 120,
        duration: 3600,
        speed: 1.25,
        playing: true,
        volume: 80,
      );

      final clientListMsg = PodkuSocketMessage(message: {}, type: PodkuSocketMessageType.clientList);

      await podkunnect.handleSocketMessage(clientListMsg);

      expect(fakeSocket.sentMessages, hasLength(1));
      final response = fakeSocket.sentMessages.first;
      expect(response.type, equals(PodkuSocketMessageType.pong));

      final pongStatus = PlayerStatus.fromJson(response.message!);
      expect(pongStatus.episode?.id, equals('ep-001'));
      expect(pongStatus.position, equals(120));
      expect(pongStatus.duration, equals(3600));
      expect(pongStatus.playing, isTrue);
    });

    test('ignores playback transfer directed to a different playerId', () async {
      final episode = Episode(id: 'ep-002', title: 'Episode 2', durationSeconds: 1800, audioUrlEncrypted: 'hash002');

      final transfer = TransferPlayback(episode: episode, position: 45, playerId: 'different-player-id');

      podkunnect.handlePlaybackTransfer(transfer);

      // Should not start playback for this device
      expect(podkunnect.playbackStatus, isNull);
    });

    test('handles remoteCommand stop by disposing player and broadcasting null status', () async {
      final player = createMockPlayer();
      final pod = Podkunnect(
        id: 'test-node-stop',
        name: 'Stop Node',
        serverUrl: 'http://localhost:8080',
        player: player,
        socket: fakeSocket,
        autoConnect: false,
      );
      await pod.connect();
      fakeSocket.sentMessages.clear();

      pod.playbackStatus = PlayerStatus(
        episode: Episode(id: 'ep-test', title: 'Test', durationSeconds: 600),
        position: 30,
        duration: 600,
        speed: 1.0,
        playing: true,
      );

      await pod.handleRemoteCommand(RemoteCommand(type: CommandType.stop));

      expect(pod.playbackStatus, isNull);
      expect(pod.player, isNull);

      expect(fakeSocket.sentMessages, hasLength(1));
      final broadcastMsg = fakeSocket.sentMessages.first;
      expect(broadcastMsg.type, equals(PodkuSocketMessageType.playerStatus));
      expect(broadcastMsg.message, isNull);

      await pod.dispose();
    });

    test('handles remoteCommand setVolume', () async {
      final player = createMockPlayer();
      final pod = Podkunnect(
        id: 'test-node-vol',
        name: 'Vol Node',
        serverUrl: 'http://localhost:8080',
        player: player,
        socket: fakeSocket,
        autoConnect: false,
      );
      await pod.connect();
      fakeSocket.sentMessages.clear();

      await pod.handleRemoteCommand(RemoteCommand(type: CommandType.setVolume, volume: 42.0));

      expect(player.state.volume, equals(42.0));
      await pod.dispose();
    });

    test('handles remoteCommand setSpeed', () async {
      final player = createMockPlayer();
      final pod = Podkunnect(
        id: 'test-node-speed',
        name: 'Speed Node',
        serverUrl: 'http://localhost:8080',
        player: player,
        socket: fakeSocket,
        autoConnect: false,
      );
      await pod.connect();
      fakeSocket.sentMessages.clear();

      await pod.handleRemoteCommand(RemoteCommand(type: CommandType.setSpeed, speed: 1.5));

      expect(player.state.rate, equals(1.5));
      await pod.dispose();
    });

    test('handles remoteCommand play and pause toggles', () async {
      final player = createMockPlayer();
      final pod = Podkunnect(
        id: 'test-node-play',
        name: 'Play Node',
        serverUrl: 'http://localhost:8080',
        player: player,
        socket: fakeSocket,
        autoConnect: false,
      );
      await pod.connect();
      fakeSocket.sentMessages.clear();

      // playOrPause on empty player executes without throwing
      await pod.handleRemoteCommand(RemoteCommand(type: CommandType.pause));
      await pod.handleRemoteCommand(RemoteCommand(type: CommandType.play));

      await pod.dispose();
    });

    test('handles unhandled socket message types gracefully', () async {
      final unhandledMsg = PodkuSocketMessage(message: {'test': 'data'}, type: PodkuSocketMessageType.playbackProgress);

      // Should not throw or crash
      await podkunnect.handleSocketMessage(unhandledMsg);
      expect(fakeSocket.sentMessages, isEmpty);
    });

    test('broadcastStatus sends formatted PodkuSocketMessage', () {
      final status = PlayerStatus(
        episode: Episode(id: 'ep-003', title: 'Status Episode', durationSeconds: 500),
        position: 10,
        duration: 500,
        speed: 1.0,
      );

      podkunnect.broadcastStatus(status, broadcast: true);

      expect(fakeSocket.sentMessages, hasLength(1));
      final sent = fakeSocket.sentMessages.first;
      expect(sent.type, equals(PodkuSocketMessageType.playerStatus));
      expect(sent.message?['position'], equals(10));
      expect(sent.message?['broadcast'], isTrue);
    });
  });
}
