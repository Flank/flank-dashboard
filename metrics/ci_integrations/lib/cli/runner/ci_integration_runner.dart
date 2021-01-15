import 'package:args/command_runner.dart';
import 'package:ci_integration/cli/command/sync_command.dart';
import 'package:ci_integration/cli/logger/logger.dart';

/// A [CommandRunner] for the CI integrations CLI.
class CiIntegrationsRunner extends CommandRunner<void> {
  /// Creates an instance of command runner and registers sub-commands available.
  CiIntegrationsRunner()
      : super('ci_integrations', 'Metrics CI integrations CLI.') {
    argParser.addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Noisy logging, including all shell commands executed.',
    );

    addCommand(SyncCommand());
  }

  @override
  Future run(Iterable<String> args) {
    final result = argParser.parse(args);
    final verbose = result['verbose'] as bool;

    Logger.setup(verbose: verbose);

    return super.run(args);
  }
}
