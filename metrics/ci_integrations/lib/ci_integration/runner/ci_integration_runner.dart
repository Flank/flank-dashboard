import 'package:args/command_runner.dart';
import 'package:ci_integration/ci_integration/command/sync_command.dart';
import 'package:ci_integration/common/logger/logger.dart';

/// A [CommandRunner] for the CI integrations CLI.
class CiIntegrationsRunner extends CommandRunner<void> {
  /// The [Logger] this runner and its commands should use for messages
  /// and errors.
  final Logger logger;

  /// Creates an instance of command runner and registers sub-commands available.
  CiIntegrationsRunner(this.logger)
      : super('ci_integrations', 'Metrics CI integrations CLI.') {
    addCommand(SyncCommand(logger));
  }
}
