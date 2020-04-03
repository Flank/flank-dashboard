import 'package:ci_integration/ci_integration/command/sync_command.dart';
import 'package:ci_integration/common/helper/file_helper.dart';
import 'package:ci_integration/common/logger/logger.dart';
import 'package:ci_integration/config/model/ci_integration_config.dart';
import 'package:test/test.dart';

import '../test_util/stub/logger_stub.dart';

void main() {
  group("SyncCommand", () {
    final logger = LoggerStub();
    SyncCommandStub syncCommand;

    setUp(() {
      syncCommand = SyncCommandStub(logger);
    });

    test("should has the 'config-file' option", () {
      final argParser = syncCommand.argParser;
      final options = argParser.options;

      expect(options, contains('config-file'));
    });

    test("should has the command name equal to 'sync'", () {
      final name = syncCommand.name;

      expect(name, equals('sync'));
    });

    test("should has non-empty description", () {
      final description = syncCommand.description;

      expect(description, isNotEmpty);
    });

    test(
      ".run() should log error if the given config file does not exist",
      () async {
        syncCommand.configFilePath = 'test.yaml';
        await syncCommand.run();

        expect(logger.errorLogsNumber, equals(1));
      },
    );

    test(
      ".run() should not run sync if the given config file does not exist",
      () async {
        syncCommand.configFilePath = 'test.yaml';
        await syncCommand.run();

        expect(syncCommand.syncCalled, isFalse);
      },
    );

    test(
      ".run() should run sync on the given config",
      () async {
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

  /// A config file path to stub the config file option parsed.
  String configFilePath = 'config.yaml';

  SyncCommandStub(Logger logger) : super(logger, fileHelper: FileHelperStub());

  @override
  Future<void> runSync(CiIntegrationConfig config) {
    _syncCalled = true;
    return Future.value();
  }

  @override
  dynamic getOptionValue(String name) {
    return configFilePath;
  }
}

/// A stub class for a [FileHelper] class providing test implementation for
/// methods.
class FileHelperStub implements FileHelper {
  @override
  bool exists(String filePath) {
    return filePath == 'config.yaml';
  }

  @override
  String read(String filePath) {
    if (exists(filePath)) {
      return '''
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
    }

    return null;
  }
}
