// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/interfaces/cli/cli.dart';

/// A class that represents the Git [Cli].
class GitCli extends Cli {
  @override
  final String executable = 'git';

  /// Clones a Git repository from the given [repoUrl]
  /// into the [targetDirectory].
  ///
  /// If the given [targetDirectory] does not exists, creates it.
  Future<void> clone(String repoUrl, String targetDirectory) {
    return run(['clone', repoUrl, targetDirectory]);
  }

  @override
  Future<void> version() async {
    try {
      await run(['--version']);
    } catch (error) {
      if (error is StateError) {
        print(error.message);
      }
    }
  }
}
