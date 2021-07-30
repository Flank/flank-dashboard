// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/services/git/cli/git_cli.dart';
import 'package:cli/services/git/git_service.dart';

/// An adapter for the [GitCli] to implement the [GitService] abstract methods.
class GitCliServiceAdapter extends GitService {
  /// A [GitCli] class that provides an ability to interact with the Git CLI.
  final GitCli _gitCli;

  /// Creates a new instance of the [GitCliServiceAdapter]
  /// with the given [GitCli].
  ///
  /// Throws an [ArgumentError] if the given [GitCli] is `null`.
  GitCliServiceAdapter(this._gitCli) {
    ArgumentError.checkNotNull(_gitCli, 'gitCli');
  }

  @override
  Future<void> checkout(String repoUrl, String targetDirectory) {
    return _gitCli.clone(repoUrl, targetDirectory);
  }

  @override
  Future<void> version() {
    return _gitCli.version();
  }
}
