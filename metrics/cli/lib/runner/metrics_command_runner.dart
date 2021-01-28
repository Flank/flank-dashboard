import 'package:args/command_runner.dart';
import 'package:cli/cli/firebase/firebase_command.dart';
import 'package:cli/cli/flutter/flutter_command.dart';
import 'package:cli/cli/gcloud/gcloud_command.dart';
import 'package:cli/cli/git/git_command.dart';
import 'package:cli/cli/npm/npm_command.dart';
import 'package:cli/deploy/deploy_command.dart';
import 'package:cli/doctor/doctor_command.dart';

/// A [CommandRunner] for the metrics CLI.
class MetricsCommandRunner extends CommandRunner<void> {
  /// Creates an instance of command runner and registers sub-commands available.
  MetricsCommandRunner() : super('metrics', 'Metrics installer.') {
    final firebase = FirebaseCommand();
    final gcloud = GCloudCommand();
    final git = GitCommand();
    final flutter = FlutterCommand();
    final npm = NpmCommand();

    addCommand(DeployCommand(firebase, gcloud, git, flutter, npm));
    addCommand(DoctorCommand(firebase, gcloud, git, flutter, npm));
  }
}
