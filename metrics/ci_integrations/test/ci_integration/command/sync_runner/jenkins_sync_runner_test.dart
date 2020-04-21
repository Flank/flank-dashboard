import 'package:ci_integration/ci_integration/command/sync_runner/jenkins_sync_runner.dart';
import 'package:ci_integration/ci_integration/config/model/raw_integration_config.dart';
import 'package:ci_integration/common/logger/logger.dart';
import 'package:ci_integration/jenkins/adapter/jenkins_source_client_adapter.dart';
import 'package:test/test.dart';

void main() {
  group("JenkinsSyncRunner", () {
    const jobName = 'jobName';
    const metricsProjectId = 'metricsProjectId';
    final logger = Logger();
    final RawIntegrationConfig config = RawIntegrationConfig(
      sourceConfigMap: {
        'url': 'url',
        'jobName': jobName,
        'username': 'username',
        'apiKey': 'apiKey',
      },
      destinationConfigMap: {
        'firebaseProjectId': 'firebaseProjectId',
        'metricsProjectId': metricsProjectId,
      },
    );
    final jenkinsSyncRunner = JenkinsSyncRunner(config, logger);

    test(
      "should create the CI config with a building job name as CI project id",
      () {
        final actualCiConfig = jenkinsSyncRunner.syncConfig;

        expect(actualCiConfig.sourceProjectId, equals(jobName));
      },
    );

    test(
      "should create the CI config with a metrics project id as storage project id",
      () {
        final actualCiConfig = jenkinsSyncRunner.syncConfig;

        expect(actualCiConfig.destinationProjectId, equals(metricsProjectId));
      },
    );

    test(".prepareCiClient() should return the Jenkins CI client", () {
      final jenkinsCiClient = jenkinsSyncRunner.prepareCiClient();

      expect(jenkinsCiClient, isA<JenkinsSourceClientAdapter>());
    });
  });
}
