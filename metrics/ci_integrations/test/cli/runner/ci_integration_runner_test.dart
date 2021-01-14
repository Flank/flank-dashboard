import 'package:ci_integration/cli/command/sync_command.dart';
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
  });
}
