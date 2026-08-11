import 'dart:io';

Future<void> main() async {
  final preCommitHook = File('.git/hooks/pre-commit');
  await preCommitHook.parent.create();
  await preCommitHook.writeAsString(
    '''
#!/bin/sh
set -e
echo "Formatting flutter app"
./submodules/flutter/bin/dart format ./src/main/app/lib
echo "Analyzing flutter app"
./submodules/flutter/bin/dart analyze ./src/main/app/lib
echo "Analyzing flutter pubspec"
./submodules/flutter/bin/dart analyze --fatal-infos ./src/main/app/pubspec.yaml
echo "Formatting podkunnect cli"
./submodules/flutter/bin/dart format  ./src/main/podkunnect/lib
echo "Analyzing podkunnect cli"
./submodules/flutter/bin/dart analyze ./src/main/podkunnect/lib
echo "Analyzing podkunnect pubspec"
./submodules/flutter/bin/dart analyze --fatal-infos ./src/main/podkunnect/pubspec.yaml
git diff --cached --name-only --diff-filter=ACM | grep '\.dart\$' | xargs -r git add
echo "Formatting Java"
mvn spotless:apply
git diff --cached --name-only --diff-filter=ACM | grep '\.java\$' | xargs -r git add
''',
  );

  if (!Platform.isWindows) {
    final result = await Process.run('chmod', ['a+x', preCommitHook.path]);
    stdout.write(result.stdout);
    stderr.write(result.stderr);
    exitCode = result.exitCode;
  }
}