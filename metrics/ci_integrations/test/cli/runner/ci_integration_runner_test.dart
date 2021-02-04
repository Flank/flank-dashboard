// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/cli/command/sync_command.dart';
import 'package:ci_integration/cli/logger/manager/logger_manager.dart';
import 'package:ci_integration/cli/runner/ci_integration_runner.dart';
import 'package:test/test.dart';

void main() {
  group("CiIntegrationsRunner", () {
    final CiIntegrationsRunner runner = CiIntegrationsRunner();

    test(
      "has an executable name equals to the 'ci_integrations'",
      () {
        final executableName = runner.executableName;

        expect(executableName, equals('ci_integrations'));
      },
    );

    test(
      "has a non-empty description",
      () {
        final description = runner.description;

        expect(description, isNotEmpty);
      },
    );

    test(
      "registers a sync command on create",
      () {
        final SyncCommand syncCommand = SyncCommand();
        final syncCommandName = syncCommand.name;

        final commands = runner.argParser.commands;

        expect(commands, contains(syncCommandName));
      },
    );

    test(
      "registers a verbose option on create",
      () {
        final options = runner.argParser.options;

        expect(options, contains('verbose'));
      },
    );

    test(".run() sets up the logger manager", () {
      final runner = CiIntegrationsRunnerStub();

      runner.run([]);

      final logger = LoggerManager.instance.getLogger(CiIntegrationsRunnerStub);

      expect(() => logger.message('test'), returnsNormally);
    });
  });
}

/// A stub class for the [CiIntegrationsRunner] used in tests
/// to remove printing the usage information for this runner.
class CiIntegrationsRunnerStub extends CiIntegrationsRunner {
  @override
  void printUsage() {}
}
