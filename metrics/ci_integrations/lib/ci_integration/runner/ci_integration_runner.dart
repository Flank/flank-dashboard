import 'package:args/command_runner.dart';
import 'package:ci_integration/ci_integration/command/sync_command.dart';

/// A [CommandRunner] for the CI integrations CLI.
class CiIntegrationsRunner extends CommandRunner<void> {
  /// Create an instance of command runner and registers sub-commands available.
  CiIntegrationsRunner()
      : super('ci_integrations', 'Metrics CI integrations CLI.') {
    addCommand(SyncCommand());
  }
}
