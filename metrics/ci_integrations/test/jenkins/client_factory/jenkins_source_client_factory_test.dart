import 'package:ci_integration/common/authorization/authorization.dart';
import 'package:ci_integration/jenkins/client_factory/jenkins_source_client_factory.dart';
import 'package:ci_integration/jenkins/config/model/jenkins_config.dart';
import 'package:ci_integration/jenkins/client/jenkins_client.dart';
import 'package:test/test.dart';

import '../test_utils/jenkins_config_test_data.dart';

void main() {
  group("JenkinsSourceClientFactory", () {
    const jenkinsSourceParty = JenkinsSourceClientFactory();
    final jenkinsConfig = JenkinsConfigTestData.jenkinsConfig;

    JenkinsClient createClient(JenkinsConfig jenkinsConfig) {
      final jenkinsClientAdapter = jenkinsSourceParty.create(jenkinsConfig);
      return jenkinsClientAdapter.jenkinsClient;
    }

    test(
      ".create() should throw ArgumentError if the given config is null",
      () {
        expect(() => jenkinsSourceParty.create(null), throwsArgumentError);
      },
    );

    test(
      ".create() should create a client for the Jenkins instance running on the given url",
      () {
        final url = jenkinsConfig.url;

        final jenkinsClient = createClient(jenkinsConfig);

        expect(jenkinsClient.jenkinsUrl, equals(url));
      },
    );

    test(
      ".create() should not create authorization if the credentials are not given",
      () {
        final jenkinsConfig = JenkinsConfig(
          url: JenkinsConfigTestData.url,
          jobName: JenkinsConfigTestData.jobName,
        );

        final jenkinsClient = createClient(jenkinsConfig);

        expect(jenkinsClient.authorization, isNull);
      },
    );

    test(
      ".create() should create a client with the given auth credentials",
      () {
        final authorization = BasicAuthorization(
          JenkinsConfigTestData.username,
          JenkinsConfigTestData.apiKey,
        );

        final jenkinsClient = createClient(jenkinsConfig);

        expect(jenkinsClient.authorization, equals(authorization));
      },
    );
  });
}
