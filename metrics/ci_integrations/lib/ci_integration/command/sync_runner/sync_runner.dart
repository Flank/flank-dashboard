import 'dart:async';
import 'dart:io';

import 'package:ci_integration/ci_integration/ci_integration.dart';
import 'package:ci_integration/ci_integration/command/sync_runner/jenkins_sync_runner.dart';
import 'package:ci_integration/common/client/ci_client.dart';
import 'package:ci_integration/common/client/storage_client.dart';
import 'package:ci_integration/common/config/ci_config.dart';
import 'package:ci_integration/config/model/ci_integration_config.dart';
import 'package:ci_integration/firestore/adapter/firestore_storage_client_adapter.dart';
import 'package:ci_integration/jenkins/config/model/jenkins_config.dart';
import 'package:firedart/firedart.dart';

/// An abstract class providing methods for running [CiIntegration.sync].
abstract class SyncRunner {
  /// The configuration for CI integrations used to define all the parts
  /// required by [CiIntegration].
  final CiIntegrationConfig config;

  const SyncRunner(this.config);

  /// Creates a specific [SyncRunner] from the given [config] declared by
  /// the [CiIntegrationConfig.source] type.
  ///
  /// If the [config] is `null` throws [ArgumentError].
  /// If the `source` represents [JenkinsConfig] returns [JenkinsSyncRunner].
  /// If the `source` represents unknown configurations returns `null`.
  factory SyncRunner.fromConfig(CiIntegrationConfig config) {
    ArgumentError.checkNotNull(config);

    if (config.source is JenkinsConfig) return JenkinsSyncRunner(config);

    return null;
  }

  /// A configuration for CI integrations used to identify project
  /// to synchronize.
  CiConfig get ciConfig;

  /// Prints the given [error] to the [stderr].
  void printError(Object error) => stderr.writeln(error);

  /// Prints the given [message] to the [stdout].
  void printMessage(Object message) => stdout.writeln(message);

  /// Prepares the [CiClient] instance for synchronization.
  FutureOr<CiClient> prepareCiClient();

  /// Prepares the [StorageClient] instance for synchronization.
  ///
  /// Default implementation prepares [Firestore] and returns
  /// the [FirestoreStorageClientAdapter] instance as a storage client.
  FutureOr<StorageClient> prepareStorageClient() {
    final firestoreConfig = config.destination;
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
        printMessage(result.message);
      } else {
        printError(result.message);
      }
    } catch (error) {
      printError('Failed to synchronize builds.\nError: $error');
    } finally {
      await dispose();
    }
  }

  /// Disposes resources taken by this runner. Generally, closes all clients if
  /// required (see [HttpClient.close]).
  FutureOr<void> dispose();
}
