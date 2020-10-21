import 'package:args/command_runner.dart';
import 'package:deploy/cli/firebase/firebase_command.dart';
import 'package:deploy/cli/flutter/flutter_command.dart';
import 'package:deploy/cli/gcloud/gcloud_command.dart';
import 'package:deploy/cli/git/git_command.dart';

/// A class providing doctor command to verify dependencies.
class DoctorCommand extends Command {
  /// A name of this command.
  @override
  final name = "doctor";

  /// A description of this command.
  @override
  final description = "Check dependencies.";

  /// A [FirebaseCommand] needed to get the Firebase CLI version.
  final _firebase = FirebaseCommand();

  /// A [GCloudCommand] needed to get the GCloud CLI version.
  final _gcloud = GCloudCommand();

  /// A [GitCommand] needed to get the Git CLI version.
  final _git = GitCommand();

  /// A [FlutterCommand] needed to get the Flutter CLI version.
  final _flutter = FlutterCommand();

  @override
  Future<void> run() async {
    await _flutter.version();
    await _firebase.version();
    await _gcloud.version();
    await _git.version();
  }
}
