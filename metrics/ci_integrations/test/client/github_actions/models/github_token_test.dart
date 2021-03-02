// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/github_actions/mappers/github_token_scope_mapper.dart';
import 'package:ci_integration/client/github_actions/models/github_token.dart';
import 'package:ci_integration/client/github_actions/models/github_token_scope.dart';
import 'package:test/test.dart';

void main() {
  group("GithubToken", () {
    const scopeStrings = [
      GithubTokenScopeMapper.repo,
    ];

    const scopes = [
      GithubTokenScope.repo,
    ];

    final tokenScopesMap = {'x-oauth-scopes': scopeStrings.join(', ')};
    const token = GithubToken(scopes: scopes);

    final map = {'test': 'test', 'x-oauth-scopes': 'repo'};

    test(
      "creates an instance with the given parameters",
      () {
        const token = GithubToken(scopes: scopes);

        expect(token.scopes, equals(scopes));
      },
    );

    test(
      ".fromMap() returns null if the given map is null",
      () {
        final token = GithubToken.fromMap(null);

        expect(token, isNull);
      },
    );

    test(
      ".fromMap() creates an instance from the given map",
      () {
        final actualToken = GithubToken.fromMap(map);

        expect(actualToken, equals(token));
      },
    );

    test(
      ".fromMap() creates an instance with scopes equal to 'x-oauth-scopes' value",
      () {
        final token = GithubToken.fromMap(map);

        expect(token.scopes, equals(scopes));
      },
    );

    test(
      ".fromMap() creates an instance with an empty scopes if the given map does not have the 'x-oauth-scopes' key",
      () {
        final map = {'test': 'test'};
        final token = GithubToken.fromMap(map);

        expect(token.scopes, isEmpty);
      },
    );

    test(
      ".toMap() converts an instance to the scope's map",
      () {
        final scopesMap = token.toMap();

        expect(scopesMap, equals(tokenScopesMap));
      },
    );
  });
}
