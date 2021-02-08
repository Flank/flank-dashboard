// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/source/jenkins/config/model/jenkins_source_config.dart';
import 'package:test/test.dart';

import '../../test_utils/test_data/jenkins_config_test_data.dart';

void main() {
  group("JenkinsSourceConfig", () {
    const jenkinsConfigJson = JenkinsConfigTestData.jenkinsSourceConfigMap;
    final jenkinsConfig = JenkinsConfigTestData.jenkinsSourceConfig;

    test(
      "throws an ArgumentError if the given url is null",
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
      "throws an ArgumentError if the given job name is null",
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
      ".fromJson() creates a new instance of the JenkinsConfig from JSON encodable Map",
      () {
        final jenkinsConfig = JenkinsSourceConfig.fromJson(jenkinsConfigJson);

        expect(jenkinsConfig, equals(jenkinsConfig));
      },
    );

    test(
      ".fromJson() returns null if null is passed",
      () {
        final config = JenkinsSourceConfig.fromJson(null);

        expect(config, isNull);
      },
    );

    test(".sourceProjectId returns the job name property value", () {
      const expected = JenkinsConfigTestData.jobName;

      final sourceProjectId = jenkinsConfig.sourceProjectId;

      expect(sourceProjectId, equals(expected));
    });
  });
}
