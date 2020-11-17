import 'package:ci_integration/cli/command/sync_command.dart';
import 'package:ci_integration/cli/logger/logger.dart';
import 'package:ci_integration/cli/runner/ci_integration_runner.dart';
import 'package:test/test.dart';

void main() {
  group("CiIntegrationsRunner", () {
    final Logger logger = Logger();
    final CiIntegrationsRunner runner = CiIntegrationsRunner(logger);

    test(
      "throws an ArgumentError if the given logger is null",
      () {
        expect(() => CiIntegrationsRunner(null), throwsArgumentError);
      },
    );

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
      "registers SyncCommand on create",
      () {
        final SyncCommand syncCommand = SyncCommand(logger);
        final syncCommandName = syncCommand.name;

        final commands = runner.argParser.commands;

        expect(commands, contains(syncCommandName));
      },
    );
  });
}
