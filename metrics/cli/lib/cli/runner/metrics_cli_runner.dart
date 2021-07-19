// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:args/command_runner.dart';
import 'package:cli/cli/command/deploy_command.dart';
import 'package:cli/cli/command/doctor_command.dart';
import 'package:cli/cli/command/update_command.dart';
import 'package:cli/cli/deployer/factory/deployer_factory.dart';
import 'package:cli/cli/doctor/factory/doctor_factory.dart';
import 'package:cli/cli/updater/factory/updater_factory.dart';

/// A [CommandRunner] implementation for the Metrics CLI.
class MetricsCliRunner extends CommandRunner<void> {
  /// Creates a new instance of the [MetricsCliRunner].
  ///
  /// Registers the [DeployCommand] and the [DoctorCommand] for this instance.
  MetricsCliRunner() : super('metrics', 'Metrics CLI.') {
    final deployerFactory = DeployerFactory();
    final doctorFactory = DoctorFactory();
    final updaterFactory = UpdaterFactory();
    final deployCommand = DeployCommand(deployerFactory);
    final doctorCommand = DoctorCommand(doctorFactory);
    final updateCommand = UpdateCommand(updaterFactory);

    addCommand(deployCommand);
    addCommand(doctorCommand);
    addCommand(updateCommand);
  }
}
