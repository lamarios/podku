import 'package:args/args.dart';
import 'package:podkunnect/cli.dart';
import 'package:test/test.dart';

void main() {
  group('CLI argument parser tests', () {
    late ArgParser parser;

    setUp(() {
      parser = buildArgParser();
    });

    test('parses required options with long flags', () {
      final result = parser.parse(['--server', 'http://localhost:8080', '--name', 'Living Room']);

      expect(result.option('server'), equals('http://localhost:8080'));
      expect(result.option('name'), equals('Living Room'));
      expect(result.option('volume'), equals('100'));
      expect(result.flag('debug'), isFalse);
    });

    test('parses options with short flags', () {
      final result = parser.parse(['-s', 'https://podku.example.com', '-n', 'Kitchen', '-v', '80', '-d']);

      expect(result.option('server'), equals('https://podku.example.com'));
      expect(result.option('name'), equals('Kitchen'));
      expect(result.option('volume'), equals('80'));
      expect(result.flag('debug'), isTrue);
    });

    test('throws ArgumentError when accessing missing mandatory --server option', () {
      final result = parser.parse(['--name', 'Bedroom']);
      expect(
        () => result.option('server'),
        throwsA(isA<ArgumentError>().having((e) => e.message, 'message', contains('server'))),
      );
    });

    test('throws ArgumentError when accessing missing mandatory --name option', () {
      final result = parser.parse(['--server', 'http://localhost:8080']);
      expect(
        () => result.option('name'),
        throwsA(isA<ArgumentError>().having((e) => e.message, 'message', contains('name'))),
      );
    });

    test('usage information includes all documented options', () {
      final usage = parser.usage;

      expect(usage, contains('--server'));
      expect(usage, contains('--name'));
      expect(usage, contains('--volume'));
      expect(usage, contains('--debug'));
    });
  });
}
