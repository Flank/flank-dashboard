import 'package:args/command_runner.dart';
import 'package:ci_integration/cli/command/sync_command.dart';
import 'package:ci_integration/cli/logger/logger.dart';

/// A [CommandRunner] for the CI integrations CLI.
class CiIntegrationsRunner extends CommandRunner<void> {
  /// The [Logger] this runner and its commands should use for messages
  /// and errors.
  final Logger logger;

  /// Creates an instance of command runner and registers sub-commands available.
  ///
  /// Throws an [ArgumentError] if the given [logger] is `null`.
  CiIntegrationsRunner(this.logger)
      : super('ci_integrations', 'Metrics CI integrations CLI.') {
    ArgumentError.checkNotNull(logger, 'logger');

    addCommand(SyncCommand(logger));
  }
}
