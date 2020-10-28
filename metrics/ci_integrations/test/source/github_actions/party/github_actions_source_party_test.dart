import 'package:ci_integration/source/github_actions/client_factory/github_actions_source_client_factory.dart';
import 'package:ci_integration/source/github_actions/config/parser/github_actions_source_config_parser.dart';
import 'package:ci_integration/source/github_actions/party/github_actions_source_party.dart';
import 'package:test/test.dart';

// https://github.com/platform-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

void main() {
  group("GithubActionsSourceParty", () {
    final githubActionsSourceParty = GithubActionsSourceParty();

    test(
      "uses GithubActionsSourceClientFactory as a client factory",
      () {
        final clientFactory = githubActionsSourceParty.clientFactory;

        expect(clientFactory, isA<GithubActionsSourceClientFactory>());
      },
    );

    test(
      "uses GithubActionsSourceConfigParser as a config parser",
      () {
        final configParser = githubActionsSourceParty.configParser;

        expect(configParser, isA<GithubActionsSourceConfigParser>());
      },
    );
  });
}
