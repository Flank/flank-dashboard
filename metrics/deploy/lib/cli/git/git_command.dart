// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:process_run/process_run.dart' as cmd;

/// A wrapper class for the Git CLI.
class GitCommand {
  /// Clones the git repository from the given [repoURL] to the given [srcPath].
  Future<void> clone(String repoURL, String srcPath) async {
    await cmd.run('git', ['clone', repoURL, srcPath], verbose: true);
  }

  /// Prints CLI version.
  Future<void> version() async {
    await cmd.run('git', ['--version'], verbose: true);
  }
}
