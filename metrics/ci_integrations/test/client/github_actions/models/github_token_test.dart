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

    const tokenJson = {'scopes': scopeStrings};
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
      ".fromJson() returns null if the given json is null",
      () {
        final token = GithubToken.fromJson(null);

        expect(token, isNull);
      },
    );

    test(
      ".fromJson() creates an instance from the given json",
      () {
        final actualToken = GithubToken.fromJson(tokenJson);

        expect(actualToken, equals(token));
      },
    );

    test(
      ".fromMap() returns null if the given headers map is null",
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
        const expectedScopes = [null];

        final map = {'test': 'test'};
        final token = GithubToken.fromMap(map);

        expect(token.scopes, equals(expectedScopes));
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
      ".listFromJson() returns null if the given list is null",
      () {
        final tokenList = GithubToken.listFromJson(null);

        expect(tokenList, isNull);
      },
    );

    test(
      ".listFromJson() returns an empty list if the given one is empty",
      () {
        final tokenList = GithubToken.listFromJson([]);

        expect(tokenList, isEmpty);
      },
    );

    test(
      ".listFromJson() creates a list of GithubToken tokens from the given list of JSON encodable objects",
      () {
        const anotherTokenJson = <String, List<String>>{'scopes': []};
        const anotherToken = GithubToken(scopes: []);
        const jsonList = [tokenJson, anotherTokenJson];
        const expectedList = [token, anotherToken];

        final tokenList = GithubToken.listFromJson(jsonList);

        expect(tokenList, equals(expectedList));
      },
    );

    test(
      ".toJson converts an instance to the json encodable map",
      () {
        final json = token.toJson();

        expect(json, equals(tokenJson));
      },
    );
  });
}
