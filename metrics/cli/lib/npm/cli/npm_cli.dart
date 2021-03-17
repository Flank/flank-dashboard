// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/interfaces/cli/cli.dart';

/// A class that represents the Npm [Cli].
class NpmCli extends Cli {
  @override
  final String executable = 'npm';

  /// Installs dependency packages to the given [workingDirectory].
  Future<void> install(String workingDirectory) async {
    await run(['install'], workingDirectory: workingDirectory);
  }

  @override
  Future<void> version() async {
    await run(['--version']);
  }
}
