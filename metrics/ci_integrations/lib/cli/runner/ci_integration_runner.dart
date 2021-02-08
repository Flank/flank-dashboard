// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:args/command_runner.dart';
import 'package:ci_integration/cli/command/sync_command.dart';
import 'package:ci_integration/cli/logger/factory/logger_factory.dart';
import 'package:ci_integration/cli/logger/manager/logger_manager.dart';

/// A [CommandRunner] for the CI integrations CLI.
class CiIntegrationsRunner extends CommandRunner<void> {
  /// A name of the flag that indicates whether to enable noisy logging or not.
  static const String _verboseFlagName = 'verbose';

  /// Creates an instance of command runner and registers sub-commands available.
  CiIntegrationsRunner()
      : super('ci_integrations', 'Metrics CI integrations CLI.') {
    argParser.addFlag(
      _verboseFlagName,
      abbr: 'v',
      help: 'Whether to enable noisy logging.',
    );

    addCommand(SyncCommand());
  }

  @override
  Future<void> run(Iterable<String> args) {
    final result = argParser.parse(args);
    final verbose = result[_verboseFlagName] as bool;

    final loggerFactory = LoggerFactory(verbose: verbose);
    LoggerManager.setLoggerFactory(loggerFactory);

    return super.run(args);
  }
}
