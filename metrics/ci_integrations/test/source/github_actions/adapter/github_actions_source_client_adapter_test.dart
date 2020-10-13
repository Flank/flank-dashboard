import 'package:archive/archive.dart';
import 'package:ci_integration/client/github_actions/github_actions_client.dart';
import 'package:ci_integration/source/github_actions/adapter/github_actions_source_client_adapter.dart';
import 'package:ci_integration/util/archive/archive_util.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

void main() {
  group("GithubActionsSourceClientAdapter", () {
    const repositoryOwner = 'owner';
    const repositoryName = 'name';
    final authorization = BearerAuthorization('token');
    final archiveUtil = ArchiveUtil(ZipDecoder());
    final client = GithubActionsClient(
      repositoryOwner: repositoryOwner,
      repositoryName: repositoryName,
      authorization: authorization,
    );

    test(
      "throws an ArgumentError if the given Github Actions client is null",
      () {
        expect(
          () => GithubActionsSourceClientAdapter(
            githubActionsClient: null,
            archiveUtil: archiveUtil,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given archive util is null",
      () {
        expect(
          () => GithubActionsSourceClientAdapter(
            githubActionsClient: client,
            archiveUtil: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        final adapter = GithubActionsSourceClientAdapter(
          githubActionsClient: client,
          archiveUtil: archiveUtil,
        );

        expect(adapter.githubActionsClient, equals(client));
        expect(adapter.archiveUtil, equals(archiveUtil));
      },
    );
  });
}
