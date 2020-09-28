import 'package:args/command_runner.dart';
import 'package:deploy/doctor/command.dart';
import 'package:deploy/deploy/command.dart';
import 'dart:async';
import 'dart:io';

Future main(List<String> arguments) async {
  CommandRunner runner = new CommandRunner("metrics", "Metrics installer.")
    ..addCommand(new DoctorCommand())
    ..addCommand(new DeployCommand());
  runner.run(arguments);
}
