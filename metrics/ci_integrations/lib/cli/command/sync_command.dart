import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:ci_integration/cli/command/ci_integration_command.dart';
import 'package:ci_integration/cli/config/model/raw_integration_config.dart';
import 'package:ci_integration/cli/config/parser/raw_integration_config_parser.dart';
import 'package:ci_integration/cli/error/sync_error.dart';
import 'package:ci_integration/cli/logger/logger.dart';
import 'package:ci_integration/cli/parties/parties.dart';
import 'package:ci_integration/cli/parties/supported_integration_parties.dart';
import 'package:ci_integration/integration/ci/ci_integration.dart';
import 'package:ci_integration/integration/ci/config/model/sync_config.dart';
import 'package:ci_integration/integration/interface/base/client/integration_client.dart';
import 'package:ci_integration/integration/interface/base/config/model/config.dart';
import 'package:ci_integration/integration/interface/base/party/integration_party.dart';
import 'package:ci_integration/integration/interface/destination/client/destination_client.dart';
import 'package:ci_integration/integration/interface/source/client/source_client.dart';

/// A class representing a [Command] for synchronizing builds.
class SyncCommand extends CiIntegrationCommand<void> {
  /// Used to parse configuration file main components.
  final _rawConfigParser = const RawIntegrationConfigParser();

  /// An instance containing all the supported [IntegrationParty]s.
  final SupportedIntegrationParties supportedParties;

  @override
  String get description =>
      'Synchronizes builds using the given configuration file.';

  @override
  String get name => 'sync';

  /// Creates an instance of this command.
  ///
  /// If the [supportedParties] is `null` the
  /// default [SupportedIntegrationParties] instance is created.
  SyncCommand({
    SupportedIntegrationParties supportedParties,
  }) : supportedParties = supportedParties ?? SupportedIntegrationParties() {
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
        Logger.printLog('Parsing the given config file..');
        final rawConfig = parseConfigFileContent(file);

        Logger.printLog('Creating integrating parties...');
        final sourceParty = getParty(
          rawConfig.sourceConfigMap,
          supportedParties.sourceParties,
        );
        final destinationParty = getParty(
          rawConfig.destinationConfigMap,
          supportedParties.destinationParties,
        );

        Logger.printLog('Creating source and destination configs...');
        final sourceConfig = parseConfig(
          rawConfig.sourceConfigMap,
          sourceParty,
        );
        final destinationConfig = parseConfig(
          rawConfig.destinationConfigMap,
          destinationParty,
        );

        Logger.printLog('Creating integrating clients...');
        sourceClient = await createClient(
          sourceConfig,
          sourceParty,
        );
        destinationClient = await createClient(
          destinationConfig,
          destinationParty,
        );

        final syncConfig = SyncConfig(
          sourceProjectId: sourceConfig.sourceProjectId,
          destinationProjectId: destinationConfig.destinationProjectId,
        );

        Logger.printLog('Syncing...');
        await sync(syncConfig, sourceClient, destinationClient);
      } catch (e) {
        throw SyncError(
          message: 'Failed to perform a sync due to the following error: $e',
        );
      } finally {
        await dispose(sourceClient, destinationClient);
      }
    } else {
      throw SyncError(
        message: 'The configuration file $configFilePath does not exist.',
      );
    }
  }

  /// Returns the configuration file by the given [configFilePath].
  File getConfigFile(String configFilePath) {
    return File(configFilePath);
  }

  /// Parses the content of the given [file] into
  /// the [RawIntegrationConfig] instance.
  RawIntegrationConfig parseConfigFileContent(File file) {
    final content = file.readAsStringSync();
    return _rawConfigParser.parse(content);
  }

  /// Returns an [IntegrationParty] element from the given
  /// [supportedParties] that matches the given [configMap].
  ///
  /// If there is no party matching the given [configMap],
  /// throws an [UnimplementedError].
  T getParty<T extends IntegrationParty>(
    Map<String, dynamic> configMap,
    Parties<T> supportedParties,
  ) {
    final party = supportedParties.parties.firstWhere(
      (party) => party.configParser.canParse(configMap),
      orElse: () => null,
    );

    if (party == null) {
      throw UnimplementedError('The given source config is unknown');
    }

    return party;
  }

  /// Parses the given [configMap] into the [Config] instance
  /// using an [IntegrationParty.configParser] of the given [party].
  T parseConfig<T extends Config>(
    Map<String, dynamic> configMap,
    IntegrationParty<T, IntegrationClient> party,
  ) {
    return party.configParser.parse(configMap);
  }

  /// Creates an [IntegrationClient] instance with the given [config]
  /// using an [IntegrationParty.clientFactory] of the given [party].
  FutureOr<T> createClient<T extends IntegrationClient>(
    Config config,
    IntegrationParty<Config, T> party,
  ) {
    return party.clientFactory.create(config);
  }

  /// Creates a [CiIntegration] instance with the given
  /// [sourceClient] and [destinationClient].
  CiIntegration createCiIntegration(
    SourceClient sourceClient,
    DestinationClient destinationClient,
  ) {
    return CiIntegration(
      sourceClient: sourceClient,
      destinationClient: destinationClient,
    );
  }

  /// Runs the [CiIntegration.sync] method on the given [syncConfig].
  Future<void> sync(
    SyncConfig syncConfig,
    SourceClient sourceClient,
    DestinationClient destinationClient,
  ) async {
    final ciIntegration = createCiIntegration(sourceClient, destinationClient);
    final result = await ciIntegration.sync(syncConfig);

    if (result.isSuccess) {
      Logger.printMessage(result.message);
    } else {
      throw SyncError(message: result.message);
    }
  }

  /// Closes both [sourceClient] and [destinationClient] and cleans up any
  /// resources associated with them.
  Future<void> dispose(
    SourceClient sourceClient,
    DestinationClient destinationClient,
  ) async {
    await sourceClient?.dispose();
    await destinationClient?.dispose();
  }
}
