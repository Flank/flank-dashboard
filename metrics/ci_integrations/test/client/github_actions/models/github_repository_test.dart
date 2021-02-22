import 'package:ci_integration/client/github_actions/models/github_repository.dart';
import 'package:ci_integration/client/github_actions/models/github_user.dart';
import 'package:test/test.dart';

void main() {
  group("GithubRepository", () {
    const id = 1;
    const name = 'name';
    const login = 'login';

    const githubRepositoryJson = {
      'id': id,
      'name': name,
      'owner': {
        'id': id,
        'login': login,
      }
    };

    const owner = GithubUser(id: id, login: login);
    const githubRepository = GithubRepository(id: id, name: name, owner: owner);

    test(
      "creates an instance with the given parameters",
      () {
        const githubRepository =
            GithubRepository(id: id, name: name, owner: owner);

        expect(githubRepository.id, equals(id));
        expect(githubRepository.name, equals(name));
        expect(githubRepository.owner, equals(owner));
      },
    );

    test(
      ".fromJson() returns null if the given json is null",
      () {
        final githubRepository = GithubRepository.fromJson(null);

        expect(githubRepository, isNull);
      },
    );

    test(
      ".listFromJson() returns null if the given list is null",
      () {
        final list = GithubRepository.listFromJson(null);

        expect(list, isNull);
      },
    );

    test(
      ".listFromJson() returns an empty list if the given one is empty",
      () {
        final list = GithubRepository.listFromJson([]);

        expect(list, isEmpty);
      },
    );

    test(
      ".listFromJson() creates a list of Github repositories from the given list of JSON encodable objects",
      () {
        const anotherId = 2;
        const anotherJson = {'id': anotherId};
        const anotherGithubRepository = GithubRepository(id: anotherId);
        const jsonList = [githubRepositoryJson, anotherJson];
        const expectedList = [githubRepository, anotherGithubRepository];

        final githubRepositoriesList = GithubRepository.listFromJson(jsonList);

        expect(githubRepositoriesList, equals(expectedList));
      },
    );

    test(
      ".toJson() converts an instance to the json encodable map",
      () {
        final json = githubRepository.toJson();

        expect(json, equals(githubRepositoryJson));
      },
    );
  });
}
