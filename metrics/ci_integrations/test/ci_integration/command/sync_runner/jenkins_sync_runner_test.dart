import 'package:ci_integration/ci_integration/command/sync_runner/jenkins_sync_runner.dart';
import 'package:ci_integration/common/logger/logger.dart';
import 'package:ci_integration/config/model/ci_integration_config.dart';
import 'package:ci_integration/firestore/config/model/firestore_config.dart';
import 'package:ci_integration/jenkins/adapter/jenkins_ci_client_adapter.dart';
import 'package:ci_integration/jenkins/config/model/jenkins_config.dart';
import 'package:test/test.dart';

void main() {
  group("JenkinsSyncRunner", () {
    const jobName = 'jobName';
    const metricsProjectId = 'metricsProjectId';

    const logger = Logger();
    final CiIntegrationConfig config = CiIntegrationConfig(
      source: JenkinsConfig(
        url: 'url',
        jobName: jobName,
        username: 'username',
        apiKey: 'apiKey',
      ),
      destination: FirestoreConfig(
        firebaseProjectId: 'firebaseProjectId',
        metricsProjectId: metricsProjectId,
      ),
    );
    final jenkinsSyncRunner = JenkinsSyncRunner(config, logger);

    test(
      "should create the CI config with a building job name as CI project id",
      () {
        final actualCiConfig = jenkinsSyncRunner.ciConfig;

        expect(actualCiConfig.ciProjectId, equals(jobName));
      },
    );

    test(
      "should create the CI config with a metrics project id as storage project id",
      () {
        final actualCiConfig = jenkinsSyncRunner.ciConfig;

        expect(actualCiConfig.storageProjectId, equals(metricsProjectId));
      },
    );

    test(".prepare() should return the Jenkins CI client", () {
      final jenkinsCiClient = jenkinsSyncRunner.prepareCiClient();

      expect(jenkinsCiClient, isA<JenkinsCiClientAdapter>());
    });
  });
}
