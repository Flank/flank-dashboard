import 'dart:io';

import 'package:ci_integration/ci_integration/command/sync_command.dart';
import 'package:ci_integration/common/logger/logger.dart';
import 'package:ci_integration/config/model/ci_integration_config.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_util/mock/file_mock.dart';
import '../test_util/stub/logger_stub.dart';

void main() {
  group("SyncCommand", () {
    const configFileContent = '''
      source:
        jenkins:
          url: sample_url
          job_name: test_project
          username: username
          apiKey: key
      destination:
        firestore:
          firebase_project_id: firebaseId
          metrics_project_id: id
    ''';
    final logger = LoggerStub();
    final FileMock fileMock = FileMock();
    SyncCommandStub syncCommand;

    setUp(() {
      reset(fileMock);
      syncCommand = SyncCommandStub(logger);
      syncCommand.fileMock = fileMock;
    });

    test("should have the 'config-file' option", () {
      final argParser = syncCommand.argParser;
      final options = argParser.options;

      expect(options, contains('config-file'));
    });

    test("should have the command name equal to 'sync'", () {
      final name = syncCommand.name;

      expect(name, equals('sync'));
    });

    test("should have a non-empty description", () {
      final description = syncCommand.description;

      expect(description, isNotEmpty);
    });

    test(
      ".run() should log an error if the given config file does not exist",
      () async {
        when(fileMock.existsSync()).thenReturn(false);
        await syncCommand.run();

        expect(logger.errorLogsNumber, equals(1));
      },
    );

    test(
      ".run() should not run sync if the given config file does not exist",
      () async {
        when(fileMock.existsSync()).thenReturn(false);
        await syncCommand.run();

        expect(syncCommand.syncCalled, isFalse);
      },
    );

    test(
      ".run() should run sync on the given config",
      () async {
        when(fileMock.existsSync()).thenReturn(true);
        when(fileMock.readAsStringSync()).thenReturn(configFileContent);
        await syncCommand.run();

        expect(syncCommand.syncCalled, isTrue);
      },
    );
  });
}

/// A stub class for a [SyncCommand] class providing test implementation for
/// methods.
class SyncCommandStub extends SyncCommand {
  /// Used to indicate that [runSync] was called.
  bool _syncCalled = false;

  bool get syncCalled => _syncCalled;

  /// A config file mock to use for testing purposes.
  FileMock fileMock;

  SyncCommandStub(Logger logger) : super(logger);

  @override
  Future<void> runSync(CiIntegrationConfig config) {
    _syncCalled = true;
    return Future.value();
  }

  @override
  File getConfigFile(String configFilePath) {
    return fileMock;
  }

  @override
  dynamic getArgumentValue(String name) {
    return 'config.yaml';
  }
}
