import 'package:args/args.dart';

ArgParser buildArgParser() {
  final parser = ArgParser();
  parser.addOption('server', abbr: 's', mandatory: true, help: 'The podku server URL');
  parser.addOption('name', abbr: 'n', mandatory: true, help: 'The name of this device');
  parser.addOption('volume', abbr: 'v', mandatory: false, defaultsTo: '100', help: 'Default volume');
  parser.addFlag('debug', abbr: 'd', help: 'Debug mode (more verbose logs)', negatable: false);
  return parser;
}
