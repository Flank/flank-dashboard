// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:cli/services/common/cli/cli.dart';

/// A class that represents the Flutter [Cli].
class FlutterCli extends Cli {
  @override
  final String executable = 'flutter';

  /// Builds a Flutter web application in the given [workingDirectory].
  Future<void> buildWeb(String workingDirectory) {
    return run(
      [
        'build',
        'web',
        '--release',
        '--source-maps',
      ],
      workingDirectory: workingDirectory,
    );
  }

  /// Enables web support for the Flutter.
  Future<void> enableWeb() {
    return run(['config', '--enable-web']);
  }

  @override
  Future<ProcessResult> version() {
    return run(['--version'], attachOutput: false);
  }
}
