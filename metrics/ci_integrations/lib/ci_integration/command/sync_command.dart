import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:ci_integration/ci_integration/ci_integration.dart';
import 'package:ci_integration/ci_integration/command/ci_integration_command.dart';
import 'package:ci_integration/ci_integration/command/sync_runner/sync_runner.dart';
import 'package:ci_integration/ci_integration/config/model/sync_config.dart';
import 'package:ci_integration/ci_integration/config/parser/raw_integration_config_parser.dart';
import 'package:ci_integration/ci_integration/parties/suppoested_integration_parties.dart';
import 'package:ci_integration/common/client/destination_client.dart';
import 'package:ci_integration/common/client/source_client.dart';
import 'package:ci_integration/common/logger/logger.dart';
import 'package:ci_integration/ci_integration/config/model/raw_integration_config.dart';
import 'package:ci_integration/common/party/destination_party.dart';
import 'package:ci_integration/common/party/source_party.dart';

/// A class representing a [Command] for synchronizing builds.
class SyncCommand extends CiIntegrationCommand<void> {
  /// Used to parse configuration file content.
  final _configParser = const RawIntegrationConfigParser();

  final SupportedIntegrationParties supportedParties;

  @override
  String get description =>
      'Synchronizes builds using the given configuration file.';

  @override
  String get name => 'sync';

  /// Creates an instance of this command with the given [logger].
  SyncCommand(
    Logger logger, {
    SupportedIntegrationParties supportedParties,
  })  : supportedParties = supportedParties ?? SupportedIntegrationParties(),
        super(logger) {
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
      SourceClient sourceClient;
      DestinationClient destinationClient;
      try {
        final rawConfig = parseConfigFileContent(file);
        final sourceParty = getSourceParty(rawConfig.sourceConfigMap);
        final destinationParty =
            getDestinationParty(rawConfig.destinationConfigMap);
        final sourceConfig =
            sourceParty.configParser.parse(rawConfig.sourceConfigMap);
        final destinationConfig =
            destinationParty.configParser.parse(rawConfig.destinationConfigMap);
        sourceClient = await sourceParty.clientFactory.create(sourceConfig);
        destinationClient =
            await destinationParty.clientFactory.create(destinationConfig);
        final syncConfig = SyncConfig(
          sourceProjectId: sourceConfig.sourceProjectId,
          destinationProjectId: destinationConfig.destinationProjectId,
        );

        await sync(syncConfig, sourceClient, destinationClient);
      } catch (e) {
        logger.printError(e);
      } finally {
        await dispose(sourceClient, destinationClient);
      }
    } else {
      logger.printError('Configuration file $configFilePath does not exist.');
    }
  }

  /// Returns the configuration file by the given [configFilePath].
  File getConfigFile(String configFilePath) {
    return File(configFilePath);
  }

  RawIntegrationConfig parseConfigFileContent(File file) {
    final content = file.readAsStringSync();
    return _configParser.parse(content);
  }

  SourceParty getSourceParty(
    Map<String, dynamic> sourceConfigMap,
  ) {
    final parties = supportedParties.supportedSourceParties.parties;
    final sourceParty = parties.firstWhere(
      (party) => party.configParser.canParse(sourceConfigMap),
      orElse: () => null,
    );

    if (sourceParty == null) {
      throw UnimplementedError('The given source config is unknown');
    }

    return sourceParty;
  }

  DestinationParty getDestinationParty(
    Map<String, dynamic> destinationConfigMap,
  ) {
    final parties = supportedParties.supportedDestinationParties.parties;
    final destinationParty = parties.firstWhere(
      (party) => party.configParser.canParse(destinationConfigMap),
      orElse: () => null,
    );

    if (destinationParty == null) {
      throw UnimplementedError('The given destination config is unknown');
    }

    return destinationParty;
  }

  /// Runs [SyncRunner.sync] on the given [config].
  Future<void> sync(
    SyncConfig syncConfig,
    SourceClient sourceClient,
    DestinationClient destinationClient,
  ) async {
    final ciIntegration = CiIntegration(
      sourceClient: sourceClient,
      destinationClient: destinationClient,
    );

    final result = await ciIntegration.sync(syncConfig);

    if (result.isSuccess) {
      logger.printMessage(result.message);
    } else {
      logger.printError(result.message);
    }
  }

  Future<void> dispose(
    SourceClient sourceClient,
    DestinationClient destinationClient,
  ) async {
    await sourceClient?.dispose();
    await destinationClient?.dispose();
  }
}
