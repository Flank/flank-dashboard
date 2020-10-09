import 'dart:io';

import 'package:ci_integration/client/github_actions/constants/github_actions_constants.dart';
import 'package:ci_integration/client/github_actions/github_actions_client.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:test/test.dart';

void main() {
  group("GithubActionsClient", () {
    const githubApiUrl = 'url';
    const repositoryOwner = 'owner';
    const repositoryName = 'name';

    final authorization = BearerAuthorization('token');

    GithubActionsClient _createClient({
      String githubApiUrl = githubApiUrl,
      String repositoryOwner = repositoryOwner,
      String repositoryName = repositoryName,
      AuthorizationBase authorization,
    }) {
      return GithubActionsClient(
        githubApiUrl: githubApiUrl,
        repositoryOwner: repositoryOwner,
        repositoryName: repositoryName,
        authorization: authorization,
      );
    }

    GithubActionsClient client;

    setUpAll(() async {
      client = _createClient();
    });

    tearDown(() async {
      client.close();
    });

    test(
      "throws an ArgumentError if the given Github API URL is null",
      () {
        expect(() => _createClient(githubApiUrl: null), throwsArgumentError);
      },
    );

    test(
      "throws an ArgumentError if the given Github API URL is empty",
      () {
        expect(() => _createClient(githubApiUrl: ''), throwsArgumentError);
      },
    );

    test(
      "throws an ArgumentError if the given repository owner is null",
      () {
        expect(() => _createClient(repositoryOwner: null), throwsArgumentError);
      },
    );

    test(
      "throws an ArgumentError if the given repository owner is empty",
      () {
        expect(() => _createClient(repositoryOwner: ''), throwsArgumentError);
      },
    );

    test(
      "throws an ArgumentError if the given repository name is null",
      () {
        expect(() => _createClient(repositoryName: null), throwsArgumentError);
      },
    );

    test(
      "throws an ArgumentError if the given repository name is empty",
      () {
        expect(() => _createClient(repositoryName: ''), throwsArgumentError);
      },
    );

    test(
      "creates an instance with the given values",
      () {
        final client = GithubActionsClient(
          githubApiUrl: githubApiUrl,
          repositoryOwner: repositoryOwner,
          repositoryName: repositoryName,
          authorization: authorization,
        );

        expect(client.githubApiUrl, equals(githubApiUrl));
        expect(client.repositoryOwner, equals(repositoryOwner));
        expect(client.repositoryName, equals(repositoryName));
        expect(client.authorization, equals(authorization));
      },
    );

    test(
      ".headers contain the 'accept' header with the GithubActionsConstants.acceptHeader value",
      () {
        final expectedHeaderValue = GithubActionsConstants.acceptHeader;

        final headers = client.headers;

        expect(
          headers,
          containsPair(HttpHeaders.acceptHeader, expectedHeaderValue),
        );
      },
    );

    test(
      ".headers include authorization info if the authorization is given",
      () {
        final client = _createClient(authorization: authorization);
        final headers = client.headers;

        final authHeader = authorization.toMap().entries.first;

        expect(headers, containsPair(authHeader.key, authHeader.value));
      },
    );

    test(
      ".headers do not include authorization info if the authorization is not given",
      () {
        final headers = client.headers;

        final authHeader = authorization.toMap().entries.first;

        expect(headers, isNot(containsPair(authHeader.key, authHeader.value)));
      },
    );
  });
}
