import 'dart:async';

import 'package:ci_integration/ci_integration/command/sync_runner/sync_runner.dart';
import 'package:ci_integration/common/authorization/authorization.dart';
import 'package:ci_integration/common/client/ci_client.dart';
import 'package:ci_integration/common/config/ci_config.dart';
import 'package:ci_integration/config/model/ci_integration_config.dart';
import 'package:ci_integration/jenkins/adapter/jenkins_ci_client_adapter.dart';
import 'package:ci_integration/jenkins/client/jenkins_client.dart';

/// A [SyncRunner] implementation for the Jenkins CI.
class JenkinsSyncRunner extends SyncRunner {
  final CiConfig _ciConfig;
  JenkinsClient _jenkinsClient;

  JenkinsSyncRunner(CiIntegrationConfig config)
      : _ciConfig = CiConfig(
          ciProjectId: config.source.jobName,
          storageProjectId: config.destination.metricsProjectId,
        ),
        super(config);

  @override
  CiConfig get ciConfig => _ciConfig;

  @override
  FutureOr<CiClient> prepareCiClient() {
    final jenkinsConfig = config.source;
    _jenkinsClient = JenkinsClient(
      url: jenkinsConfig.url,
      authorization: BasicAuthorization(
        jenkinsConfig.username,
        jenkinsConfig.apiKey,
      ),
    );

    return JenkinsCiClientAdapter(_jenkinsClient);
  }

  @override
  FutureOr<void> dispose() {
    _jenkinsClient?.close();
  }
}
