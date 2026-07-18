import 'dart:io';

Future<void> main() async {
  final preCommitHook = File('.git/hooks/pre-commit');
  await preCommitHook.parent.create();
  await preCommitHook.writeAsString(
    '''
#!/bin/sh
set -e
exec ./submodules/flutter/bin/dart format --set-exit-if-changed ./podku_flutter/lib
exec ./submodules/flutter/bin/dart analyze ./podku_flutter/lib
exec ./submodules/flutter/bin/dart analyze --fatal-infos ./podku_flutter/pubspec.yaml

exec ./submodules/flutter/bin/dart format --set-exit-if-changed ./podku_server/lib
exec ./submodules/flutter/bin/dart analyze ./podku_server/lib
exec ./submodules/flutter/bin/dart analyze --fatal-infos ./podku_server/pubspec.yaml
''',
  );

  if (!Platform.isWindows) {
    final result = await Process.run('chmod', ['a+x', preCommitHook.path]);
    stdout.write(result.stdout);
    stderr.write(result.stderr);
    exitCode = result.exitCode;
  }
}