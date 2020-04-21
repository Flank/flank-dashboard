import 'dart:async';
import 'dart:io';

import 'package:ci_integration/ci_integration/ci_integration.dart';
import 'package:ci_integration/ci_integration/command/sync_runner/jenkins_sync_runner.dart';
import 'package:ci_integration/common/client/destination_client.dart';
import 'package:ci_integration/common/client/source_client.dart';
import 'package:ci_integration/ci_integration/config/model/sync_config.dart';
import 'package:ci_integration/common/logger/logger.dart';
import 'package:ci_integration/ci_integration/config/model/raw_integration_config.dart';
import 'package:ci_integration/firestore/adapter/firestore_destination_client_adapter.dart';
import 'package:ci_integration/jenkins/config/model/jenkins_config.dart';
import 'package:firedart/firedart.dart';

/// An abstract class providing methods for running [CiIntegration.sync].
abstract class SyncRunner {
  /// The [Logger] for this sync runner.
  final Logger logger;

  /// The configuration for CI integrations used to define all the parts
  /// required by [CiIntegration].
  final RawIntegrationConfig config;

  /// A configuration for CI integrations used to identify project
  /// to synchronize.
  SyncConfig get syncConfig;

  /// Creates an instance of [SyncRunner] with the given [config] and [logger].
  ///
  /// Throws [ArgumentError] if either the given [config] or [logger] is `null`.
  SyncRunner(this.config, this.logger) {
    ArgumentError.checkNotNull(config);
    ArgumentError.checkNotNull(logger);
  }

  /// Creates a specific [SyncRunner] from the given [config] declared by
  /// the [RawIntegrationConfig.sourceConfigMap] type.
  ///
  /// If the [config] is `null` throws an [ArgumentError].
  /// If the `source` represents [JenkinsConfig] returns [JenkinsSyncRunner].
  /// If the `source` represents unknown configurations returns `null`.
  factory SyncRunner.fromConfig(RawIntegrationConfig config, Logger logger) {
    ArgumentError.checkNotNull(config);

    if (config.sourceConfigMap is JenkinsConfig) {
      return JenkinsSyncRunner(config, logger);
    }

    return null;
  }

  /// Prepares the [SourceClient] instance for synchronization.
  FutureOr<SourceClient> prepareCiClient();

  /// Prepares the [DestinationClient] instance for synchronization.
  ///
  /// Default implementation prepares [Firestore] and returns
  /// the [FirestoreDestinationClientAdapter] instance as a storage client.
  FutureOr<DestinationClient> prepareStorageClient() {
    final firestoreConfig = config.destinationConfigMap;
    final firestore = Firestore(firestoreConfig);

    return FirestoreDestinationClientAdapter(firestore);
  }

  /// Runs the [CiIntegration.sync] method after all preparations required.
  Future<void> sync() async {
    try {
      final CiIntegration ciIntegration = CiIntegration(
        sourceClient: await prepareCiClient(),
        destinationClient: await prepareStorageClient(),
      );
      final result = await ciIntegration.sync(syncConfig);

      if (result.isSuccess) {
        logger.printMessage(result.message);
      } else {
        logger.printError(result.message);
      }
    } catch (error) {
      logger.printError('Failed to synchronize builds.\nError: $error');
    } finally {
      await dispose();
    }
  }

  /// Disposes resources taken by this runner. Generally, closes all clients if
  /// required (see [HttpClient.close]).
  FutureOr<void> dispose();
}
