import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:ci_integration/ci_integration/command/sync_runner/sync_runner.dart';
import 'package:ci_integration/config/parser/ci_integration_config_parser.dart';

/// A class representing a [Command] for synchronizing builds.
class SyncCommand extends Command<void> {
  final _configParser = const CiIntegrationConfigParser();

  @override
  String get description =>
      'Synchronizes builds using the given configurations.';

  @override
  String get name => 'sync';

  /// Creates an instance of this command.
  SyncCommand() {
    argParser.addOption(
      'config-file',
      help: 'A path to the YAML configuration file.',
      valueHelp: 'config.yaml',
    );
  }

  @override
  Future<void> run() async {
    final configFilepath = argResults['config-file'] as String;
    final configFile = File(configFilepath);

    if (configFile.existsSync()) {
      final content = configFile.readAsStringSync();
      final config = _configParser.parse(content);
      final syncRunner = SyncRunner.fromConfig(config);
      await syncRunner.sync();
    } else {
      stderr.writeln(
        'Configuration file $configFilepath does not exist.',
      );
    }
  }
}
