// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:args/command_runner.dart';
import 'package:cli/cli/updater/config/factory/update_config_factory.dart';
import 'package:cli/cli/updater/factory/updater_factory.dart';
import 'package:cli/cli/updater/updater.dart';
import 'package:cli/common/model/config/update_config.dart';

/// A [Command] that updates the deployed Metrics components.
class UpdateCommand extends Command {
  /// A name of the option that holds a path to the YAML configuration file.
  static const _configFileOptionName = 'config-file';

  @override
  final name = 'update';

  @override
  final description = 'Updates the deployed Metrics components.';

  /// An [UpdaterFactory] this command uses to create a [Updater].
  final UpdaterFactory _updaterFactory;

  /// An [UpdateConfigFactory] this command uses to create an [UpdateConfig].
  final UpdateConfigFactory _updateConfigFactory;

  /// Creates a new instance of the [UpdateCommand].
  ///
  /// If the given [updateConfigFactory] is `null`, an instance of the
  /// [UpdateConfigFactory] is used.
  ///
  /// Throws an [ArgumentError] if the given [UpdaterFactory] is `null`.
  UpdateCommand(
    this._updaterFactory, {
    UpdateConfigFactory updateConfigFactory,
  }) : _updateConfigFactory =
            updateConfigFactory ?? const UpdateConfigFactory() {
    ArgumentError.checkNotNull(_updaterFactory, 'updaterFactory');

    argParser.addOption(
      _configFileOptionName,
      help: 'A path to the YAML configuration file.',
      valueHelp: 'config.yaml',
    );
  }

  @override
  Future<void> run() {
    final configPath = argResults[_configFileOptionName] as String;
    final config = _updateConfigFactory.create(configPath);
    final updater = _updaterFactory.create();

    return updater.update(config);
  }
}
