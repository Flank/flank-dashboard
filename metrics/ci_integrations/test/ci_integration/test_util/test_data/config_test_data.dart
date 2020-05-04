import 'package:ci_integration/ci_integration/config/model/raw_integration_config.dart';
import 'package:ci_integration/ci_integration/config/model/sync_config.dart';
import 'package:ci_integration/firestore/config/model/firestore_destination_config.dart';
import 'package:ci_integration/jenkins/config/model/jenkins_source_config.dart';

/// A class containing a test data for the different sync configurations
/// as [RawIntegrationConfig], [SyncConfig] and others.
///
/// Used in tests for CLI synchronization command.
class ConfigTestData {
  static const String jenkinsUrl = 'url';
  static const String jenkinsJobName = 'testProject';
  static const String jenkinsUsername = 'username';
  static const String jenkinsApiKey = 'apiKey';

  static const String firebaseProjectId = 'firebaseId';
  static const String metricsProjectId = 'metricsProjectId';

  static const configFileContent = '''
      source:
        jenkins:
          url: $jenkinsUrl
          job_name: $jenkinsJobName
          username: $jenkinsUsername
          api_key: $jenkinsApiKey
      destination:
        firestore:
          firebase_project_id: $firebaseProjectId
          metrics_project_id: $metricsProjectId
      ''';

  static final JenkinsSourceConfig jenkinsSourceConfig = JenkinsSourceConfig(
    url: jenkinsUrl,
    jobName: jenkinsJobName,
    username: jenkinsUsername,
    apiKey: jenkinsApiKey,
  );

  static final FirestoreDestinationConfig firestoreConfig = FirestoreDestinationConfig(
    firebaseProjectId: firebaseProjectId,
    metricsProjectId: metricsProjectId,
  );

  static final RawIntegrationConfig integrationConfig = RawIntegrationConfig(
    sourceConfigMap: const {
      'jenkins': {
        'url': jenkinsUrl,
        'job_name': jenkinsJobName,
        'username': jenkinsUsername,
        'api_key': jenkinsApiKey,
      },
    },
    destinationConfigMap: const {
      'firestore': {
        'firebase_project_id': firebaseProjectId,
        'metrics_project_id': metricsProjectId,
      },
    },
  );

  static final SyncConfig syncConfig = SyncConfig(
    destinationProjectId: metricsProjectId,
    sourceProjectId: jenkinsJobName,
  );
}
