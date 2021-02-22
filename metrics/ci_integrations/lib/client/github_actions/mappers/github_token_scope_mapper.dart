// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/github_actions/models/github_token_scope.dart';
import 'package:ci_integration/integration/interface/base/client/mapper/mapper.dart';

/// A class that provides methods for mapping Github token scopes.
class GithubTokenScopeMapper implements Mapper<String, GithubTokenScope> {
  /// A token scope that allows to access to private and public repositories.
  static const String repo = 'repo';

  /// Creates a new instance of the [GithubTokenScopeMapper].
  const GithubTokenScopeMapper();

  @override
  GithubTokenScope map(String value) {
    switch (value) {
      case repo:
        return GithubTokenScope.repo;
      default:
        return null;
    }
  }

  @override
  String unmap(GithubTokenScope value) {
    switch (value) {
      case GithubTokenScope.repo:
        return repo;
      default:
        return null;
    }
  }
}
