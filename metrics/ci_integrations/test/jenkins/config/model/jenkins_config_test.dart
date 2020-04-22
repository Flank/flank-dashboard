import 'package:ci_integration/jenkins/config/model/jenkins_config.dart';
import 'package:test/test.dart';

void main() {
  group("JenkinsConfig", () {
    const url = 'url';
    const username = 'username';
    const apiKey = 'apiKey';
    const jobName = 'jobName';

    final jenkinsConfigJson = {
      'url': url,
      'username': username,
      'api_key': apiKey,
      'job_name': jobName,
    };

    final jenkinsConfig = JenkinsConfig(
      url: url,
      jobName: jobName,
      username: username,
      apiKey: apiKey,
    );

    test(
      "can't be created with null url",
      () {
        expect(
          () => JenkinsConfig(jobName: 'jobId', url: null),
          throwsArgumentError,
        );
      },
    );

    test(
      "can't be created with null jobName",
      () {
        expect(
          () => JenkinsConfig(url: 'url', jobName: null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".fromJson() should create a new instance of the JenkinsConfig from json encodable Map",
      () {
        final jenkinsConfig = JenkinsConfig.fromJson(jenkinsConfigJson);

        expect(jenkinsConfig, equals(jenkinsConfig));
      },
    );

    test(
      ".fromJson() should return null if null is passed",
      () {
        final config = JenkinsConfig.fromJson(null);

        expect(config, isNull);
      },
    );

    test(".sourceProjectId should return the jobName property value", () {
      const expected = jobName;

      final sourceProjectId = jenkinsConfig.sourceProjectId;

      expect(sourceProjectId, equals(expected));
    });
  });
}
