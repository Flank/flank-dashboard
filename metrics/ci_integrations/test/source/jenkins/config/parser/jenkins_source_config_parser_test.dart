import 'package:ci_integration/source/jenkins/config/parser/jenkins_source_config_parser.dart';
import 'package:test/test.dart';

import '../../test_utils/test_data/jenkins_config_test_data.dart';

// ignore_for_file: prefer_const_constructors

void main() {
  group("JenkinsSourceConfigParser", () {
    const jenkinsConfigMap = {
      'jenkins': JenkinsConfigTestData.jenkinsSourceConfigMap,
    };
    final jenkinsConfig = JenkinsConfigTestData.jenkinsSourceConfig;

    final jenkinsConfigParser = JenkinsSourceConfigParser();

    test(".canParse() should return false if the given map is null", () {
      final canParse = jenkinsConfigParser.canParse(null);

      expect(canParse, isFalse);
    });

    test(
      ".canParse() should return false if the given map does not contain a Jenkins key",
      () {
        final map = {'test': {}};

        final canParse = jenkinsConfigParser.canParse(map);

        expect(canParse, isFalse);
      },
    );

    test(
      ".canParse() should return true if the parser can parse the given map",
      () {
        final canParse = jenkinsConfigParser.canParse(jenkinsConfigMap);

        expect(canParse, isTrue);
      },
    );

    test(
      ".parse() should return null if the given map is null",
      () {
        final result = jenkinsConfigParser.parse(null);

        expect(result, isNull);
      },
    );

    test(
      ".parse() should return null if the given map does not contain a Jenkins key",
      () {
        final map = {'test': {}};

        final result = jenkinsConfigParser.parse(map);

        expect(result, isNull);
      },
    );

    test(
      ".parse() should parse the given map into the JenkinsConfig",
      () {
        final result = jenkinsConfigParser.parse(jenkinsConfigMap);

        expect(result, equals(jenkinsConfig));
      },
    );
  });
}
