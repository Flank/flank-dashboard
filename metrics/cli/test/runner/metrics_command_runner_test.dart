import 'package:cli/deploy/deploy_command.dart';
import 'package:cli/doctor/doctor_command.dart';
import 'package:cli/runner/metrics_command_runner.dart';
import 'package:test/test.dart';

void main() {
  group("MetricsCommandRunner", () {
    final runner = MetricsCommandRunner();

    test("has an executable name equals to the 'ci_integrations'", () {
      final executableName = runner.executableName;

      expect(executableName, equals('metrics'));
    });

    test("has a non-empty description", () {
      final description = runner.description;

      expect(description, isNotEmpty);
    });

    test("registers DoctorCommand on create", () {
      final DoctorCommand doctorCommand = DoctorCommand();
      final doctorCommandName = doctorCommand.name;

      final commands = runner.argParser.commands;

      expect(commands, contains(doctorCommandName));
    });

    test("registers DeployCommand on create", () {
      final DeployCommand deployCommand = DeployCommand();
      final deployCommandName = deployCommand.name;

      final commands = runner.argParser.commands;

      expect(commands, contains(deployCommandName));
    });
  });
}
