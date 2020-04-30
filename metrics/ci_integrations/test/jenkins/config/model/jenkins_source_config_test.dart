import 'package:ci_integration/jenkins/config/model/jenkins_source_config.dart';
import 'package:test/test.dart';

import '../../test_utils/jenkins_config_test_data.dart';

void main() {
  group("JenkinsSourceConfig", () {
    const jenkinsConfigJson = JenkinsConfigTestData.jenkinsConfigMap;
    final jenkinsConfig = JenkinsConfigTestData.jenkinsConfig;

    test(
      "can't be created with null url",
      () {
        expect(
          () => JenkinsSourceConfig(
            jobName: JenkinsConfigTestData.jobName,
            url: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "can't be created with null jobName",
      () {
        expect(
          () => JenkinsSourceConfig(
            url: JenkinsConfigTestData.url,
            jobName: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      ".fromJson() should create a new instance of the JenkinsConfig from json encodable Map",
      () {
        final jenkinsConfig = JenkinsSourceConfig.fromJson(jenkinsConfigJson);

        expect(jenkinsConfig, equals(jenkinsConfig));
      },
    );

    test(
      ".fromJson() should return null if null is passed",
      () {
        final config = JenkinsSourceConfig.fromJson(null);

        expect(config, isNull);
      },
    );

    test(".sourceProjectId should return the jobName property value", () {
      const expected = JenkinsConfigTestData.jobName;

      final sourceProjectId = jenkinsConfig.sourceProjectId;

      expect(sourceProjectId, equals(expected));
    });
  });
}
