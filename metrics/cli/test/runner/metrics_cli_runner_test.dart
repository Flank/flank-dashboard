// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/deploy/command/deploy_command.dart';
import 'package:cli/deploy/factory/deployer_factory.dart';
import 'package:cli/doctor/command/doctor_command.dart';
import 'package:cli/doctor/factory/doctor_factory.dart';
import 'package:cli/runner/metrics_cli_runner.dart';
import 'package:test/test.dart';

void main() {
  group("MetricsCliRunner", () {
    final runner = MetricsCliRunner();
    final deployerFactory = DeployerFactory();
    final doctorFactory = DoctorFactory();
    final deployCommand = DeployCommand(deployerFactory);
    final doctorCommand = DoctorCommand(doctorFactory);
    final deployCommandName = deployCommand.name;
    final doctorCommandName = doctorCommand.name;

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

    test(
      "creates a doctor command with the doctor factory",
      () {
        final command = runner.commands[doctorCommandName] as DoctorCommand;

        expect(command?.doctorFactory, isNotNull);
      },
    );
  });
}
