// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/cli/command/deploy_command.dart';
import 'package:cli/cli/command/doctor_command.dart';
import 'package:cli/cli/command/update_command.dart';
import 'package:cli/cli/deployer/factory/deployer_factory.dart';
import 'package:cli/cli/doctor/factory/doctor_factory.dart';
import 'package:cli/cli/runner/metrics_cli_runner.dart';
import 'package:cli/cli/updater/factory/updater_factory.dart';
import 'package:test/test.dart';

void main() {
  group("MetricsCliRunner", () {
    final runner = MetricsCliRunner();

    test(
      ".executableName equals to the 'metrics'",
      () {
        final executableName = runner.executableName;

        expect(executableName, equals('metrics'));
      },
    );

    test(
      ".description is not empty",
      () {
        final description = runner.description;

        expect(description, isNotEmpty);
      },
    );

    test(
      "registers a deploy command on create",
      () {
        final deployerFactory = DeployerFactory();
        final deployCommand = DeployCommand(deployerFactory);
        final deployCommandName = deployCommand.name;

        final commands = runner.argParser.commands;

        expect(commands, contains(deployCommandName));
      },
    );

    test(
      "registers a doctor command on create",
      () {
        final doctorFactory = DoctorFactory();
        final doctorCommand = DoctorCommand(doctorFactory);
        final doctorCommandName = doctorCommand.name;

        final commands = runner.argParser.commands;

        expect(commands, contains(doctorCommandName));
      },
    );

    test(
      "registers an update command on create",
      () {
        final updateFactory = UpdaterFactory();
        final updateCommand = UpdateCommand(updateFactory);
        final updateCommandName = updateCommand.name;

        final commands = runner.argParser.commands;

        expect(commands, contains(updateCommandName));
      },
    );
  });
}
