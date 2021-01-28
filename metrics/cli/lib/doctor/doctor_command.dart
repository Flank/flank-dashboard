import 'package:args/command_runner.dart';
import 'package:cli/cli/firebase/firebase_command.dart';
import 'package:cli/cli/flutter/flutter_command.dart';
import 'package:cli/cli/gcloud/gcloud_command.dart';
import 'package:cli/cli/git/git_command.dart';
import 'package:cli/cli/npm/npm_command.dart';

/// A [Command] implementation that verifies the dependencies.
class DoctorCommand extends Command<void> {
  @override
  final String name = "doctor";

  @override
  final String description = "Check dependencies.";

  /// A [FirebaseCommand] needed to get the Firebase CLI version.
  final FirebaseCommand _firebase;

  /// A [GCloudCommand] needed to get the GCloud CLI version.
  final GCloudCommand _gcloud;

  /// A [GitCommand] needed to get the Git CLI version.
  final GitCommand _git;

  /// A [FlutterCommand] needed to get the Flutter CLI version.
  final FlutterCommand _flutter;

  /// A [NpmCommand] needed to get the Npm CLI version.
  final NpmCommand _npm;

  /// Creates an instance of the [DeployCommand].
  DoctorCommand(
    this._firebase,
    this._gcloud,
    this._git,
    this._flutter,
    this._npm,
  );

  @override
  Future<void> run() async {
    await _flutter.version();
    await _firebase.version();
    await _gcloud.version();
    await _git.version();
    await _npm.version();
  }
}
