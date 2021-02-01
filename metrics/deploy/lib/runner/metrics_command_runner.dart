import 'package:args/command_runner.dart';
import 'package:cli/deploy/deploy_command.dart';
import 'package:cli/doctor/doctor_command.dart';

/// A [CommandRunner] for the metrics CLI.
class MetricsCommandRunner extends CommandRunner<void> {
  /// Creates an instance of command runner and registers sub-commands available.
  MetricsCommandRunner() : super('metrics', 'Metrics installer.') {
    addCommand(DoctorCommand());
    addCommand(DeployCommand());
  }
}
