import 'dart:io';

Future<void> main() async {
  final preCommitHook = File('.git/hooks/pre-commit');
  await preCommitHook.parent.create();
  await preCommitHook.writeAsString(
    '''
#!/bin/sh
set -e
exec ./submodules/flutter/bin/dart format --set-exit-if-changed ./src/main/app/lib
exec ./submodules/flutter/bin/dart analyze ./src/main/app/lib
exec ./submodules/flutter/bin/dart analyze --fatal-infos ./src/main/app/pubspec.yaml
exec ./submodules/flutter/bin/dart format --set-exit-if-changed ./src/main/podkunnect/lib
exec ./submodules/flutter/bin/dart analyze ./src/main/podkunnect/lib
exec ./submodules/flutter/bin/dart analyze --fatal-infos ./src/main/podkunnect/pubspec.yaml
exec mvn spotless:apply
exec git diff --cached --name-only --diff-filter=ACM | grep '\.java\$' | xargs -r git add
''',
  );

  if (!Platform.isWindows) {
    final result = await Process.run('chmod', ['a+x', preCommitHook.path]);
    stdout.write(result.stdout);
    stderr.write(result.stderr);
    exitCode = result.exitCode;
  }
}