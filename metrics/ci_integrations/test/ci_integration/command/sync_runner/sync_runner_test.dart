import 'dart:async';

import 'package:ci_integration/ci_integration/command/sync_runner/jenkins_sync_runner.dart';
import 'package:ci_integration/ci_integration/command/sync_runner/sync_runner.dart';
import 'package:ci_integration/common/client/ci_client.dart';
import 'package:ci_integration/common/client/storage_client.dart';
import 'package:ci_integration/common/config/ci_config.dart';
import 'package:ci_integration/common/logger/logger.dart';
import 'package:ci_integration/config/model/ci_integration_config.dart';
import 'package:ci_integration/firestore/config/model/firestore_config.dart';
import 'package:ci_integration/jenkins/config/model/jenkins_config.dart';
import 'package:test/test.dart';

import '../../test_util/testbed/ci_client_testbed.dart';
import '../../test_util/testbed/storage_client_testbed.dart';

void main() {
  group("SyncRunner", () {
    final logger = LoggerTestbed();
    final CiIntegrationConfig config = CiIntegrationConfig(
      source: JenkinsConfig(
        url: 'url',
        jobName: 'jobName',
        username: 'username',
        apiKey: 'apiKey',
      ),
      destination: FirestoreConfig(
        firebaseProjectId: 'firebaseProjectId',
        metricsProjectId: 'metricsProjectId',
      ),
    );
    final syncRunner = SyncRunnerTestbed(config, logger);

    setUp(() {
      logger.clearLogs();
      syncRunner.clearDisposeCalls();
    });

    test(
      "should throw ArgumentError trying to create an instance with null config",
      () {
        expect(() => SyncRunnerTestbed(null, logger), throwsArgumentError);
      },
    );

    test(
      "should throw ArgumentError trying to create an instance with null logger",
      () {
        expect(() => SyncRunnerTestbed(config, null), throwsArgumentError);
      },
    );

    test(
      ".fromConfig should throw ArgumentError if the given config is null",
      () {
        expect(() => SyncRunner.fromConfig(null, logger), throwsArgumentError);
      },
    );

    test(
      ".fromConfig should create JenkinsSyncRunner for Jenkins config",
      () {
        final syncRunner = SyncRunner.fromConfig(config, logger);

        expect(syncRunner, isA<JenkinsSyncRunner>());
      },
    );

    test(
      ".sync() must call .dispose() once",
      () async {
        await syncRunner.sync();
        expect(syncRunner.disposeCalls, equals(1));
      },
    );

    test(".sync() should log error if synchronization is failed", () async {
      final syncRunner = SyncRunnerTestbed(
        config,
        logger,
        storageClient: StorageClientTestbed(
          addBuildsCallback: (_, __) => throw UnimplementedError(),
        ),
      );

      await syncRunner.sync();
      expect(logger.errorLogsNumber, equals(1));
    });

    test(
      ".sync() should log success message if synchronization is successful",
      () async {
        await syncRunner.sync();
        expect(logger.messageLogsNumber, equals(1));
      },
    );
  });
}

/// A testbed class for a [SyncRunner] abstract class providing a test
/// implementation.
class LoggerTestbed implements Logger {
  /// Used to store all error log requests.
  final List<Object> _errorLogs = [];

  /// Used to store all message log requests.
  final List<Object> _messageLogs = [];

  /// Clears all log requests.
  void clearLogs() {
    _errorLogs.clear();
    _messageLogs.clear();
  }

  /// The number of error log requests performed.
  int get errorLogsNumber => _errorLogs.length;

  /// The number of message log requests performed.
  int get messageLogsNumber => _messageLogs.length;

  @override
  void printError(Object error) {
    _errorLogs.add(error);
  }

  @override
  void printMessage(Object message) {
    _messageLogs.add(message);
  }
}

/// A testbed class for a [SyncRunner] abstract class providing a test
/// implementation.
class SyncRunnerTestbed extends SyncRunner {
  final StorageClient _storageClient;
  final CiClient _ciClient;

  /// Used to store number of [dispose] calls.
  int _disposeCalls = 0;

  int get disposeCalls => _disposeCalls;

  @override
  CiConfig get ciConfig => CiConfig(
        ciProjectId: 'ciProjectId',
        storageProjectId: 'storageProjectId',
      );

  SyncRunnerTestbed(
    CiIntegrationConfig config,
    Logger logger, {
    StorageClient storageClient,
    CiClient ciClient,
  })  : _storageClient = storageClient ?? StorageClientTestbed(),
        _ciClient = ciClient ?? CiClientTestbed(),
        super(config, logger);

  @override
  FutureOr<StorageClient> prepareStorageClient() => _storageClient;

  @override
  FutureOr<CiClient> prepareCiClient() => _ciClient;

  @override
  FutureOr<void> dispose() {
    _disposeCalls += 1;
  }

  /// Sets the dispose calls number to `0`.
  void clearDisposeCalls() {
    _disposeCalls = 0;
  }
}
