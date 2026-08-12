import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:media_kit/media_kit.dart';
import 'package:podkunnect/podkunnect.dart';

final _log = Logger('main');

void main(List<String> arguments) {
  MediaKit.ensureInitialized();
  var parser = ArgParser();

  parser.addOption("server", abbr: 's', mandatory: true, help: 'The podku server URL');
  parser.addOption("name", abbr: 'n', mandatory: true, help: 'The name of this device');
  parser.addFlag('debug', abbr: 'd', help: 'Debug mode (more verbose logs)', negatable: false);
  var result = parser.parse(arguments);

  Logger.root.level = result.flag('debug') ? Level.FINEST : Level.INFO;
  Logger.root.onRecord.listen((record) {
    print('[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}');
    if (record.error != null) {
      print('Error: ${record.error}');
    }
    if (record.stackTrace != null) {
      print(record.stackTrace);
    }
  });

  try {
    _log.info(
      "Starting podkunnect with name: ${result.option("name")} and server: ${result.option('server')}, debug? ${result.flag('debug')}",
    );
  } catch (e) {
    _log.info(parser.usage);
    return;
  }
  Podkunnect(name: result.option('name')!, serverUrl: result.option('server')!);
}
