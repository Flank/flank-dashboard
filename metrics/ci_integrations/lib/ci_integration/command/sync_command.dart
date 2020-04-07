import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:ci_integration/ci_integration/command/ci_integration_command.dart';
import 'package:ci_integration/ci_integration/command/sync_runner/sync_runner.dart';
import 'package:ci_integration/common/logger/logger.dart';
import 'package:ci_integration/config/model/ci_integration_config.dart';
import 'package:ci_integration/config/parser/ci_integration_config_parser.dart';

/// A class representing a [Command] for synchronizing builds.
class SyncCommand extends CiIntegrationCommand<void> {
  /// Used to parse configuration file content.
  final _configParser = const CiIntegrationConfigParser();

  @override
  String get description =>
      'Synchronizes builds using the given configuration file.';

  @override
  String get name => 'sync';

  /// Creates an instance of this command with the given [logger].
  SyncCommand(Logger logger) : super(logger) {
    argParser.addOption(
      'config-file',
      help: 'A path to the YAML configuration file.',
      valueHelp: 'config.yaml',
    );
  }

  @override
  Future<void> run() async {
    final configFilePath = getArgumentValue('config-file') as String;
    final file = getConfigFile(configFilePath);

    if (file.existsSync()) {
      final content = file.readAsStringSync();
      final config = _configParser.parse(content);
      await runSync(config);
    } else {
      logger.printError('Configuration file $configFilePath does not exist.');
    }
  }

  /// Returns the configuration file by the given [configFilePath].
  File getConfigFile(String configFilePath) {
    return File(configFilePath);
  }

  /// Runs [SyncRunner.sync] on the given [config].
  Future<void> runSync(CiIntegrationConfig config) {
    final syncRunner = SyncRunner.fromConfig(config, logger);
    return syncRunner.sync();
  }
}
