import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nock/nock.dart';
import 'package:podku/server/states/server.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    nock.init();
  });

  setUp(() {
    nock.cleanAll();
    SharedPreferences.setMockInitialValues({});
  });

  test('ServerCubit rejects invalid server URLs', () async {
    final cubit = ServerCubit(const ServerState());
    final success = await cubit.setServerUrl('not-a-url', testServer: false);

    expect(success, isFalse);
    expect(cubit.state.serverUrl, isNull);
    expect(cubit.state.status, InternetConnectionStatus.disconnected);
    expect(cubit.state.initialized, isFalse);
    await cubit.close();
  });

  test('ServerCubit connects and strips trailing slash on valid URL', () async {
    const baseUrl = 'http://localhost:8080';
    nock(baseUrl).get('/api/podcasts')
      .reply(
        200,
        jsonEncode([]),
        headers: {'content-type': 'application/json'},
      );

    final cubit = ServerCubit(const ServerState());
    final success = await cubit.setServerUrl('$baseUrl/', testServer: true);

    expect(success, isTrue);
    expect(cubit.state.serverUrl, baseUrl);
    expect(cubit.state.initialized, isTrue);
    expect(cubit.state.status, InternetConnectionStatus.connected);
    expect(cubit.state.client, isNotNull);
    await cubit.close();
  });

  test('ServerCubit emits error when server test fails', () async {
    const errorServer = 'http://failed-server:8080';
    nock(errorServer).get('/api/podcasts')
      .reply(
        500,
        'Server Error',
        headers: {'content-type': 'text/plain'},
      );

    final cubit = ServerCubit(const ServerState());
    final success = await cubit.setServerUrl(errorServer, testServer: true);

    expect(success, isFalse);
    expect(cubit.state.error, isNotNull);
    expect(cubit.state.initialized, isFalse);
    await cubit.close();
  });
}
