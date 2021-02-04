// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/jenkins/jenkins_client.dart';
import 'package:ci_integration/source/jenkins/client_factory/jenkins_source_client_factory.dart';
import 'package:ci_integration/source/jenkins/config/model/jenkins_source_config.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:test/test.dart';

import '../test_utils/test_data/jenkins_config_test_data.dart';

void main() {
  group("JenkinsSourceClientFactory", () {
    const jenkinsSourceParty = JenkinsSourceClientFactory();
    final jenkinsConfig = JenkinsConfigTestData.jenkinsSourceConfig;

    JenkinsClient createClient(JenkinsSourceConfig jenkinsConfig) {
      final jenkinsClientAdapter = jenkinsSourceParty.create(jenkinsConfig);
      return jenkinsClientAdapter.jenkinsClient;
    }

    test(
      ".create() throws an ArgumentError if the given config is null",
      () {
        expect(() => jenkinsSourceParty.create(null), throwsArgumentError);
      },
    );

    test(
      ".create() creates a client for the Jenkins instance running on the given url",
      () {
        final url = jenkinsConfig.url;

        final jenkinsClient = createClient(jenkinsConfig);

        expect(jenkinsClient.jenkinsUrl, equals(url));
      },
    );

    test(
      ".create() does not create authorization if the credentials are not given",
      () {
        final jenkinsConfig = JenkinsSourceConfig(
          url: JenkinsConfigTestData.url,
          jobName: JenkinsConfigTestData.jobName,
        );

        final jenkinsClient = createClient(jenkinsConfig);

        expect(jenkinsClient.authorization, isNull);
      },
    );

    test(
      ".create() creates a client with the given auth credentials",
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
