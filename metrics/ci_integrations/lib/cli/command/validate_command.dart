// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/cli/command/ci_integration_command.dart';
import 'package:ci_integration/cli/config/factory/raw_integration_config_factory.dart';
import 'package:ci_integration/cli/config/model/raw_integration_config.dart';
import 'package:ci_integration/cli/configured_parties/configured_parties.dart';
import 'package:ci_integration/cli/configured_parties/configured_party.dart';
import 'package:ci_integration/cli/configured_parties/factory/configured_parties_factory.dart';
import 'package:ci_integration/cli/logger/mixin/logger_mixin.dart';
import 'package:ci_integration/integration/error/config_validation_error.dart';
import 'package:ci_integration/integration/interface/base/config/model/config.dart';
import 'package:ci_integration/integration/interface/base/config/validator/config_validator.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class representing a [CiIntegrationCommand] for [Config] file validation.
class ValidateCommand extends CiIntegrationCommand<void> with LoggerMixin {
  /// A name of the option that holds a path to the YAML configuration file.
  static const _configFileOptionName = 'config-file';

  /// A [RawIntegrationConfigFactory] this command uses to create a
  /// [RawIntegrationConfig].
  final RawIntegrationConfigFactory rawIntegrationConfigFactory;

  /// A [ConfiguredPartiesFactory] this command uses to create a
  /// [ConfiguredParties].
  final ConfiguredPartiesFactory configuredPartiesFactory;

  /// A [ValidationResultPrinter] this command uses to print
  /// the [ValidationResult]s.
  final ValidationResultPrinter validationResultPrinter;

  @override
  String get description => 'Validates the given configuration file.';

  @override
  String get name => 'validate';

  /// Creates a new instance of the [ValidateCommand].
  ///
  /// If the given [rawIntegrationConfigFactory] is null, an instance of the
  /// [RawIntegrationConfigFactory] is used.
  /// If the given [configuredPartiesFactory] is null, an instance of the
  /// [ConfiguredPartiesFactory] is used.
  /// If the given [validationResultPrinter] is null, an instance of the
  /// [ValidationResultPrinter] is used.
  ValidateCommand({
    RawIntegrationConfigFactory rawIntegrationConfigFactory,
    ConfiguredPartiesFactory configuredPartiesFactory,
    ValidationResultPrinter validationResultPrinter,
  })  : rawIntegrationConfigFactory =
            rawIntegrationConfigFactory ?? const RawIntegrationConfigFactory(),
        configuredPartiesFactory =
            configuredPartiesFactory ?? ConfiguredPartiesFactory(),
        validationResultPrinter =
            validationResultPrinter ?? ValidationResultPrinter() {
    argParser.addOption(
      _configFileOptionName,
      help: 'A path to the YAML configuration file to validate.',
      valueHelp: 'config.yaml',
    );
  }

  @override
  Future<void> run() async {
    final configFilePath = getArgumentValue(_configFileOptionName) as String;

    try {
      final rawIntegrationConfig = rawIntegrationConfigFactory.create(
        configFilePath,
      );

      final configuredParties = configuredPartiesFactory.create(
        rawIntegrationConfig,
      );

      final configuredSourceParty = configuredParties.configuredSourceParty;
      final configuredDestinationParty =
          configuredParties.configuredDestinationParty;

      await _validate(configuredSourceParty);

      await _validate(configuredDestinationParty);
    } catch (e) {
      throw ConfigValidationError(
        message: 'Failed to validate the config due to the following error: $e',
      );
    }
  }

  /// Creates the [ConfigValidator] and runs the validation
  /// for the given [ConfiguredParty.party].
  Future<void> _validate(ConfiguredParty configuredParty) async {
    final config = configuredParty.config;

    final configValidator = _createConfigValidator(configuredParty);

    logger.message('Validating ${config.runtimeType}...');

    final validationResult = await configValidator.validate(config);

    validationResultPrinter.print(validationResult);
  }

  /// Creates the [ConfigValidator] using the given [configuredParty].
  ConfigValidator _createConfigValidator(
    ConfiguredParty configuredParty,
  ) {
    final party = configuredParty.party;
    final config = configuredParty.config;

    final configValidatorFactory = party.configValidatorFactory;

    return configValidatorFactory.create(config);
  }
}
