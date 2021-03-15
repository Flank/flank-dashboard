// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/interfaces/cli/cli.dart';

/// A [CLI] implementation for the Flutter.
class FlutterCli extends Cli {
  @override
  String get name => 'flutter';

  /// Builds a Flutter web application in the given [workingDirectory].
  Future<void> buildWeb(String workingDirectory) async {
    await run(['build', 'web'], workingDirectory: workingDirectory);
  }

  /// Enables web support for the Flutter.
  Future<void> enableWeb() async {
    await run(['config', '--enable-web']);
  }

  @override
  Future<void> version() async {
    await run(['--version']);
  }
}
