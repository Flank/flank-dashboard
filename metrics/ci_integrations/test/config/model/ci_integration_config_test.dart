import 'package:ci_integration/config/model/ci_integration_config.dart';
import 'package:ci_integration/firestore/config/model/firestore_config.dart';
import 'package:ci_integration/jenkins/config/model/jenkins_config.dart';
import 'package:test/test.dart';

void main() {
  group("CiIntegrationConfig", () {
    test(
      "can't be creates when the source is null",
      () {
        expect(
          () => CiIntegrationConfig(
            source: null,
            destination: FirestoreConfigTestbed(),
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "can't be creates when the destination is null",
      () {
        expect(
          () => CiIntegrationConfig(
            source: JenkinsConfigTestbed(),
            destination: null,
          ),
          throwsArgumentError,
        );
      },
    );
  });
}

class JenkinsConfigTestbed implements JenkinsConfig {
  @override
  String get jobName => null;

  @override
  String get password => null;

  @override
  String get url => null;

  @override
  String get username => null;
}

class FirestoreConfigTestbed implements FirestoreConfig {
  @override
  String get firestoreProjectId => null;

  @override
  String get metricsProjectId => null;
}
