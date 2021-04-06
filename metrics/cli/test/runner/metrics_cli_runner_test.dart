// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/deploy/deploy_command.dart';
import 'package:cli/deploy/factory/deployer_factory.dart';
import 'package:cli/doctor/doctor_command.dart';
import 'package:cli/runner/metrics_cli_runner.dart';
import 'package:test/test.dart';

void main() {
  group("MetricsCliRunner", () {
    final runner = MetricsCliRunner();
    final deployerFactory = DeployerFactory();
    final deployCommand = DeployCommand(deployerFactory);
    final deployCommandName = deployCommand.name;

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
        final commands = runner.argParser.commands;

        expect(commands, contains(deployCommandName));
      },
    );

    test(
      "registers a doctor command on create",
      () {
        final doctorCommand = DoctorCommand();
        final doctorCommandName = doctorCommand.name;

        final commands = runner.argParser.commands;

        expect(commands, contains(doctorCommandName));
      },
    );

    test(
      "creates a deploy command with the deployer factory",
      () {
        final command = runner.commands[deployCommandName] as DeployCommand;

        expect(command?.deployerFactory, isNotNull);
      },
    );
  });
}
