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

import '../../test_util/stub/ci_client_stub.dart';
import '../../test_util/stub/logger_stub.dart';
import '../../test_util/stub/storage_client_stub.dart';

void main() {
  group("SyncRunner", () {
    final logger = LoggerStub();
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
        firebaseUserPassword: 'firebaseUserPassword',
        firebaseUserEmail: 'firebaseUserEmail',
        firebaseAuthApiKey: 'firebaseAuthApiKey',
      ),
    );
    final syncRunner = SyncRunnerStub(config, logger);

    setUp(() {
      logger.clearLogs();
      syncRunner.clearDisposeCalls();
    });

    test(
      "should throw ArgumentError trying to create an instance with null config",
      () {
        expect(() => SyncRunnerStub(null, logger), throwsArgumentError);
      },
    );

    test(
      "should throw ArgumentError trying to create an instance with null logger",
      () {
        expect(() => SyncRunnerStub(config, null), throwsArgumentError);
      },
    );

    test(
      ".fromConfig() should throw ArgumentError if the given config is null",
      () {
        expect(() => SyncRunner.fromConfig(null, logger), throwsArgumentError);
      },
    );

    test(
      ".fromConfig() should create JenkinsSyncRunner for Jenkins config",
      () {
        final syncRunner = SyncRunner.fromConfig(config, logger);

        expect(syncRunner, isA<JenkinsSyncRunner>());
      },
    );

    test(
      ".prepareStorageClient() should return the class that implements storage client",
      () async {
        final syncRunner = SyncRunnerStub(
          config,
          logger,
          storageClientCallback: () => StorageClientStub(
            addBuildsCallback: (_, __) => throw UnimplementedError(),
          ),
        );
        final storageClient = await syncRunner.prepareStorageClient();

        expect(storageClient, isA<StorageClient>());
      },
    );

    test(
      ".sync() must call .dispose() once",
      () async {
        await syncRunner.sync();
        expect(syncRunner.disposeCalls, equals(1));
      },
    );

    test(".sync() should log an error if synchronization is failed", () async {
      final syncRunner = SyncRunnerStub(
        config,
        logger,
        storageClientCallback: () => StorageClientStub(
          addBuildsCallback: (_, __) => throw UnimplementedError(),
        ),
      );

      await syncRunner.sync();
      expect(logger.errorLogsNumber, equals(1));
    });

    test(".sync() should log an error if sync throws", () async {
      final syncRunner = SyncRunnerStub(
        config,
        logger,
        storageClientCallback: () => throw UnimplementedError(),
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

/// A stub class for a [SyncRunner] abstract class providing a test
/// implementation.
class SyncRunnerStub extends SyncRunner {
  final StorageClient Function() _storageClientCallback;
  final CiClient Function() _ciClientCallback;

  /// Used to store number of [dispose] calls.
  int _disposeCalls = 0;

  int get disposeCalls => _disposeCalls;

  @override
  CiConfig get ciConfig => CiConfig(
        ciProjectId: 'ciProjectId',
        storageProjectId: 'storageProjectId',
      );

  SyncRunnerStub(
    CiIntegrationConfig config,
    Logger logger, {
    StorageClient Function() storageClientCallback,
    CiClient Function() ciClientCallback,
  })  : _storageClientCallback = storageClientCallback,
        _ciClientCallback = ciClientCallback,
        super(config, logger);

  @override
  FutureOr<StorageClient> prepareStorageClient() {
    if (_storageClientCallback != null) {
      return _storageClientCallback();
    }
    return StorageClientStub();
  }

  @override
  FutureOr<CiClient> prepareCiClient() {
    if (_ciClientCallback != null) {
      return _ciClientCallback();
    }
    return CiClientStub();
  }

  @override
  FutureOr<void> dispose() {
    _disposeCalls += 1;
  }

  /// Sets the dispose calls number to `0`.
  void clearDisposeCalls() {
    _disposeCalls = 0;
  }
}
