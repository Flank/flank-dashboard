import 'package:ci_integration/config/model/ci_integration_config.dart';
import 'package:ci_integration/firestore/config/model/firestore_config.dart';
import 'package:ci_integration/jenkins/config/model/jenkins_config.dart';
import 'package:test/test.dart';

void main() {
  group("CiIntegrationConfig", () {
    test(
      "can't be created when the source is null",
      () {
        expect(
          () => CiIntegrationConfig(
            source: null,
            destination: FirestoreConfig(
              firebaseProjectId: 'firebaseId',
              metricsProjectId: 'metricsId',
            ),
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "can't be created when the destination is null",
      () {
        expect(
          () => CiIntegrationConfig(
            source: JenkinsConfig(
              url: 'url',
              jobName: 'jobName',
              username: 'username',
              password: 'password',
            ),
            destination: null,
          ),
          throwsArgumentError,
        );
      },
    );
  });
}
