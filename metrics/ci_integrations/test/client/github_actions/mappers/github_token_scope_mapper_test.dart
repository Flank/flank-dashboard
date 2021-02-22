// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/github_actions/mappers/github_token_scope_mapper.dart';
import 'package:ci_integration/client/github_actions/models/github_token_scope.dart';
import 'package:test/test.dart';

void main() {
  group("GithubTokenScopeMapper", () {
    const mapper = GithubTokenScopeMapper();

    test(
      ".map() maps the repo scope to the GithubTokenScope.repo",
      () {
        const expectedScope = GithubTokenScope.repo;

        final scope = mapper.map(GithubTokenScopeMapper.repo);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.repo to the repo scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.repo;

        final scope = mapper.unmap(GithubTokenScope.repo);

        expect(scope, equals(expectedScope));
      },
    );
  });
}
