// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:cli/services/common/cli/cli.dart';

/// A class that represents the Npm [Cli].
class NpmCli extends Cli {
  @override
  final String executable = 'npm';

  /// Installs npm dependencies in the given [workingDirectory].
  Future<void> install(String workingDirectory) {
    return run(['install'], workingDirectory: workingDirectory);
  }

  @override
  Future<ProcessResult> version() {
    return run(['--version'], attachOutput: false);
  }
}
