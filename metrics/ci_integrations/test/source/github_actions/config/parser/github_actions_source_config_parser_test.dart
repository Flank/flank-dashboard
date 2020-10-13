import 'package:ci_integration/source/github_actions/config/parser/github_actions_source_config_parser.dart';
import 'package:test/test.dart';

import '../../test_utils/test_data/github_actions_config_test_data.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

void main() {
  group("GithubActionsSourceConfigParser", () {
    const configMap = {
      'github_actions': GithubActionsConfigTestData.sourceConfigMap,
    };

    final githubActionsConfigParser = GithubActionsSourceConfigParser();

    test(
      ".canParse() returns false if the given map is null",
      () {
        final canParse = githubActionsConfigParser.canParse(null);

        expect(canParse, isFalse);
      },
    );

    test(
      ".canParse() returns false if the given map does not contain a Github Actions key",
      () {
        final map = {'test': {}};

        final canParse = githubActionsConfigParser.canParse(map);

        expect(canParse, isFalse);
      },
    );

    test(
      ".canParse() returns true if the parser can parse the given map",
      () {
        final canParse = githubActionsConfigParser.canParse(configMap);

        expect(canParse, isTrue);
      },
    );

    test(
      ".parse() returns null if the given map is null",
      () {
        final result = githubActionsConfigParser.parse(null);

        expect(result, isNull);
      },
    );

    test(
      ".parse() returns null if the given map does not contain a Github Actions key",
      () {
        final map = {'test': {}};

        final result = githubActionsConfigParser.parse(map);

        expect(result, isNull);
      },
    );

    test(
      ".parse() parses the given map into the GithubActionsSourceConfig",
      () {
        final expected = GithubActionsConfigTestData.sourceConfig;

        final result = githubActionsConfigParser.parse(configMap);

        expect(result, equals(expected));
      },
    );
  });
}
