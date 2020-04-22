import 'package:ci_integration/jenkins/config/model/jenkins_config.dart';
import 'package:ci_integration/jenkins/config/parser/jenkins_config_parser.dart';
import 'package:test/test.dart';

void main() {
  group("JenkinsConfigParser", () {
    const jenkinsConfigParser = JenkinsConfigParser();

    const url = 'url';
    const username = 'username';
    const apiKey = 'apiKey';
    const jobName = 'jobName';

    final jenkinsConfigMap = {
      'jenkins': {
        'url': url,
        'username': username,
        'api_key': apiKey,
        'job_name': jobName,
      },
    };

    final jenkinsConfig = JenkinsConfig(
      url: url,
      jobName: jobName,
      username: username,
      apiKey: apiKey,
    );

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
      ".parse() should parse the given map into the JenkisnConfig",
      () {
        final result = jenkinsConfigParser.parse(jenkinsConfigMap);

        expect(result, equals(jenkinsConfig));
      },
    );
  });
}
