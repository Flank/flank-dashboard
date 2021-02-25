// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/github_actions/models/github_token.dart';

/// An enum that represents the scope of the [GithubToken].
enum GithubTokenScope {
  /// A token scope that allows access to private and public repositories.
  repo,
}
