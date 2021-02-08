// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/cli/config/model/raw_integration_config.dart';
import 'package:ci_integration/destination/firestore/config/model/firestore_destination_config.dart';
import 'package:ci_integration/integration/ci/config/model/sync_config.dart';
import 'package:ci_integration/source/jenkins/config/model/jenkins_source_config.dart';

import '../../../destination/firestore/test_utils/test_data/firestore_config_test_data.dart';
import '../../../source/jenkins/test_utils/test_data/jenkins_config_test_data.dart';

/// A class containing a test data for the different sync configurations
/// as [RawIntegrationConfig], [SyncConfig] and others.
///
/// Used in tests for CLI synchronization command.
class ConfigTestData {
  static const String configFileContent = '''
      source:
        jenkins:
          url: ${JenkinsConfigTestData.url}
          job_name: ${JenkinsConfigTestData.jobName}
          username: ${JenkinsConfigTestData.username}
          api_key: ${JenkinsConfigTestData.apiKey}
      destination:
        firestore:
          firebase_project_id: ${FirestoreConfigTestData.firebaseProjectId}
          firebase_user_email: ${FirestoreConfigTestData.firebaseUserEmail}
          firebase_user_pass: ${FirestoreConfigTestData.firebaseUserPassword}
          firebase_public_api_key: ${FirestoreConfigTestData.firebasePublicApiKey}
          metrics_project_id: ${FirestoreConfigTestData.metricsProjectId}
      ''';

  static final JenkinsSourceConfig jenkinsSourceConfig =
      JenkinsConfigTestData.jenkinsSourceConfig;

  static final FirestoreDestinationConfig firestoreConfig =
      FirestoreConfigTestData.firestoreDestiantionConfig;

  static final RawIntegrationConfig integrationConfig = RawIntegrationConfig(
    sourceConfigMap: const {
      'jenkins': JenkinsConfigTestData.jenkinsSourceConfigMap,
    },
    destinationConfigMap: const {
      'firestore': FirestoreConfigTestData.firestoreDestinationConfigMap,
    },
  );

  static final SyncConfig syncConfig = SyncConfig(
    destinationProjectId: FirestoreConfigTestData.metricsProjectId,
    sourceProjectId: JenkinsConfigTestData.jobName,
    initialSyncLimit: 20,
    coverage: false,
  );
}
