import 'package:args/command_runner.dart';
import 'package:deploy/doctor/command.dart';
import 'package:deploy/deploy/command.dart';

Future main(List<String> arguments) async {
  final runner = CommandRunner("metrics", "Metrics installer.")
    ..addCommand(DoctorCommand())
    ..addCommand(DeployCommand());
  await runner.run(arguments);
}
