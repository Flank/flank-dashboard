import 'package:ci_integration/jenkins/config/parser/jenkins_config_parser.dart';
import 'package:test/test.dart';

import '../../test_utils/jenkins_config_test_data.dart';

// ignore_for_file: prefer_const_constructors

void main() {
  group("JenkinsConfigParser", () {
    const jenkinsConfigMap = {
      'jenkins': JenkinsConfigTestData.jenkinsConfigMap,
    };
    final jenkinsConfig = JenkinsConfigTestData.jenkinsConfig;

    final jenkinsConfigParser = JenkinsConfigParser();

    test(".canParse() should return false if the given map is null", () {
      final canParse = jenkinsConfigParser.canParse(null);

      expect(canParse, isFalse);
    });

    test(
      ".canParse() should return false if the given map does not contain a jenkins key",
      () {
        final map = {'test': {}};

        final canParse = jenkinsConfigParser.canParse(map);

        expect(canParse, isFalse);
      },
    );

    test(
      ".canParse() should return true if parser can parse the given map",
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
      ".parse() should return null if the given map does not contain a jenkins key",
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
