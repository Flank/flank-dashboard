import 'dart:async';
import 'dart:io';

import 'package:ci_integration/ci_integration/ci_integration.dart';
import 'package:ci_integration/ci_integration/command/sync_runner/jenkins_sync_runner.dart';
import 'package:ci_integration/common/client/ci_client.dart';
import 'package:ci_integration/common/client/storage_client.dart';
import 'package:ci_integration/common/config/ci_config.dart';
import 'package:ci_integration/common/logger/logger.dart';
import 'package:ci_integration/config/model/ci_integration_config.dart';
import 'package:ci_integration/firestore/adapter/firestore_storage_client_adapter.dart';
import 'package:ci_integration/jenkins/config/model/jenkins_config.dart';
import 'package:firedart/firedart.dart';

/// An abstract class providing methods for running [CiIntegration.sync].
abstract class SyncRunner {
  /// The [Logger] for this sync runner.
  final Logger logger;

  /// The configuration for CI integrations used to define all the parts
  /// required by [CiIntegration].
  final CiIntegrationConfig config;

  /// A configuration for CI integrations used to identify project
  /// to synchronize.
  CiConfig get ciConfig;

  /// Creates an instance of [SyncRunner] with the given [config] and [logger].
  ///
  /// Throws [ArgumentError] if either the given [config] or [logger] is `null`.
  SyncRunner(this.config, this.logger) {
    ArgumentError.checkNotNull(config);
    ArgumentError.checkNotNull(logger);
  }

  /// Creates a specific [SyncRunner] from the given [config] declared by
  /// the [CiIntegrationConfig.source] type.
  ///
  /// If the [config] is `null` throws an [ArgumentError].
  /// If the `source` represents [JenkinsConfig] returns [JenkinsSyncRunner].
  /// If the `source` represents unknown configurations returns `null`.
  factory SyncRunner.fromConfig(CiIntegrationConfig config, Logger logger) {
    ArgumentError.checkNotNull(config);

    if (config.source is JenkinsConfig) {
      return JenkinsSyncRunner(config, logger);
    }

    return null;
  }

  /// Prepares the [CiClient] instance for synchronization.
  FutureOr<CiClient> prepareCiClient();

  /// Prepares the [StorageClient] instance for synchronization.
  ///
  /// Default implementation prepares [Firestore] and returns
  /// the [FirestoreStorageClientAdapter] instance as a storage client.
  FutureOr<StorageClient> prepareStorageClient() async {
    final firestoreConfig = config.destination;
    final auth = FirebaseAuth.initialize(
      firestoreConfig.firebaseAuthApiKey,
      VolatileStore(),
    );

    await auth.signIn(
      firestoreConfig.firebaseUserEmail,
      firestoreConfig.firebaseUserPassword,
    );

    final firestore = Firestore(firestoreConfig.firebaseProjectId);
    return FirestoreStorageClientAdapter(firestore);
  }

  /// Runs the [CiIntegration.sync] method after all preparations required.
  Future<void> sync() async {
    try {
      final CiIntegration ciIntegration = CiIntegration(
        ciClient: await prepareCiClient(),
        storageClient: await prepareStorageClient(),
      );
      final result = await ciIntegration.sync(ciConfig);

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
