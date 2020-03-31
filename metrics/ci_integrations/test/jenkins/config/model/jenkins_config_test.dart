import 'package:ci_integration/jenkins/config/model/jenkins_config.dart';
import 'package:test/test.dart';

void main() {
  group("JenkinsConfig", () {
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
      ".fromJson() creates new instance of JenkinsConfig from json encodable Map",
      () {
        const url = 'url';
        const username = 'username';
        const apiKey = 'apiKey';
        const buildJobName = 'job_name';

        final jenkinsConfigJson = {
          'url': url,
          'username': username,
          'apiKey': apiKey,
          'job_name': buildJobName,
        };

        final jenkinsConfig = JenkinsConfig.fromJson(jenkinsConfigJson);

        expect(jenkinsConfig.url, url);
        expect(jenkinsConfig.username, username);
        expect(jenkinsConfig.apiKey, apiKey);
        expect(jenkinsConfig.jobName, buildJobName);
      },
    );

    test(
      ".fromJson() return null if null is passed",
      () {
        final config = JenkinsConfig.fromJson(null);

        expect(config, isNull);
      },
    );
  });
}
