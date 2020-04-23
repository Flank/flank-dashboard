import 'package:ci_integration/ci_integration/command/sync_command.dart';
import 'package:ci_integration/ci_integration/runner/ci_integration_runner.dart';
import 'package:ci_integration/common/logger/logger.dart';
import 'package:test/test.dart';

void main() {
  group("CiIntegrationsRunner", () {
    final Logger logger = Logger();
    final CiIntegrationsRunner runner = CiIntegrationsRunner(logger);

    test(
      "should throw an AgrumentError trying to create an instance with null logger",
      () {
        expect(() => CiIntegrationsRunner(null), throwsArgumentError);
      },
    );

    test(
      "should have the executable name equals to the 'ci_integrations'",
      () {
        final executableName = runner.executableName;

        expect(executableName, equals('ci_integrations'));
      },
    );

    test(
      "should have a non-empty description",
      () {
        final description = runner.description;

        expect(description, isNotEmpty);
      },
    );

    test(
      "should register SyncCommand on create",
      () {
        final SyncCommand syncCommand = SyncCommand(logger);
        final syncCommandName = syncCommand.name;

        final commands = runner.argParser.commands;

        expect(commands, contains(syncCommandName));
      },
    );
  });
}
