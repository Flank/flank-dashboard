import 'package:args/command_runner.dart';
import 'package:deploy/cli/firebase/firebase_command.dart';
import 'package:deploy/cli/flutter/flutter_command.dart';
import 'package:deploy/cli/gcloud/gcloud_command.dart';
import 'package:deploy/cli/git/git_command.dart';

/// class providing doctor command to verify dependencies.
class DoctorCommand extends Command {
  @override
  final name = "doctor";
  @override
  final description = "Check dependencies.";

  final _firebase = FirebaseCommand();
  final _gcloud = GCloudCommand();
  final _git = GitCommand();
  final _flutter = FlutterCommand();

  DoctorCommand();

  @override
  Future<void> run() async {
    await _flutter.version();
    await _firebase.version();
    await _gcloud.version();
    await _git.version();
  }
}
