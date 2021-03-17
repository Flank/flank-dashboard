// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/interfaces/cli/cli.dart';

/// A class that represents the Git [Cli].
class GitCli extends Cli {
  @override
  final String executable = 'git';

  /// Clones a Git repository from the given [repoUrl] into
  /// a newly created [directory].
  Future<void> clone(String repoUrl, String directory) {
    return run(['clone', repoUrl, directory]);
  }

  @override
  Future<void> version() {
    return run(['--version']);
  }
}
