// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/github_actions/models/github_user.dart';
import 'package:test/test.dart';

void main() {
  group("GithubUser", () {
    const id = 1;
    const login = 'login';

    const githubUserJson = {
      'id': id,
      'login': login,
    };

    const githubUser = GithubUser(id: id, login: login);

    test(
      "creates an instance with the given parameters",
      () {
        const githubUser = GithubUser(id: id, login: login);

        expect(githubUser.id, equals(id));
        expect(githubUser.login, equals(login));
      },
    );

    test(
      ".fromJson() returns null if the given json is null",
      () {
        final githubUser = GithubUser.fromJson(null);

        expect(githubUser, isNull);
      },
    );

    test(
      ".fromJson() creates an instance from the given json",
      () {
        final actualGithubUser = GithubUser.fromJson(githubUserJson);

        expect(actualGithubUser, equals(githubUser));
      },
    );

    test(
      ".listFromJson() returns null if the given list is null",
      () {
        final list = GithubUser.listFromJson(null);

        expect(list, isNull);
      },
    );

    test(
      ".listFromJson() returns an empty list if the given one is empty",
      () {
        final list = GithubUser.listFromJson([]);

        expect(list, isEmpty);
      },
    );

    test(
      ".listFromJson() creates a list of Github users from the given list of JSON encodable objects",
      () {
        const anotherId = 2;
        const anotherJson = {'id': anotherId};
        const anotherGithubUser = GithubUser(id: anotherId);
        const jsonList = [githubUserJson, anotherJson];
        const expectedList = [githubUser, anotherGithubUser];

        final pipelineList = GithubUser.listFromJson(jsonList);

        expect(pipelineList, equals(expectedList));
      },
    );

    test(
      ".toJson() converts an instance to the json encodable map",
      () {
        final json = githubUser.toJson();

        expect(json, equals(githubUserJson));
      },
    );
  });
}
