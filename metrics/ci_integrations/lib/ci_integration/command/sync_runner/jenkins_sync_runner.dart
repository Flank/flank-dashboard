import 'dart:async';

import 'package:ci_integration/ci_integration/command/sync_runner/sync_runner.dart';
import 'package:ci_integration/common/authorization/authorization.dart';
import 'package:ci_integration/common/client/source_client.dart';
import 'package:ci_integration/ci_integration/config/model/sync_config.dart';
import 'package:ci_integration/common/logger/logger.dart';
import 'package:ci_integration/ci_integration/config/model/raw_integration_config.dart';
import 'package:ci_integration/jenkins/adapter/jenkins_source_client_adapter.dart';
import 'package:ci_integration/jenkins/client/jenkins_client.dart';

/// A [SyncRunner] implementation for the Jenkins CI.
class JenkinsSyncRunner extends SyncRunner {
  @override
  final SyncConfig syncConfig;

  JenkinsClient _jenkinsClient;

  JenkinsSyncRunner(RawIntegrationConfig config, Logger logger)
      : syncConfig = SyncConfig(
          sourceProjectId: config.sourceConfigMap,
          destinationProjectId: config.destinationConfigMap.metricsProjectId,
        ),
        super(config, logger);

  @override
  FutureOr<SourceClient> prepareCiClient() {
    final jenkinsConfig = config.sourceConfigMap;
    _jenkinsClient = JenkinsClient(
      url: jenkinsConfig.url,
      authorization: BasicAuthorization(
        jenkinsConfig.username,
        jenkinsConfig.apiKey,
      ),
    );

    return JenkinsSourceClientAdapter(_jenkinsClient);
  }

  @override
  FutureOr<void> dispose() {
    _jenkinsClient?.close();
  }
}
