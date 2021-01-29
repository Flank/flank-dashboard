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
  final String description = "Checks dependencies.";

  /// A [FirebaseCommand] this command uses to get the Firebase CLI version.
  final FirebaseCommand _firebase;

  /// A [GCloudCommand] this command uses to get the GCloud CLI version.
  final GCloudCommand _gcloud;

  /// A [GitCommand] this command uses to get the Git CLI version.
  final GitCommand _git;

  /// A [FlutterCommand] this command uses to get the Flutter CLI version.
  final FlutterCommand _flutter;

  /// A [NpmCommand] this command uses to get the Npm CLI version.
  final NpmCommand _npm;

  /// Creates a new instance of the [DoctorCommand].
  ///
  /// If the given [firebase] is `null`, the [FirebaseCommand] instance is used.
  /// If the given [gcloud] is `null`, the [GCloudCommand] instance is used.
  /// If the given [git] is `null`, the [GitCommand] instance is used.
  /// If the given [flutter] is `null`, the [FlutterCommand] instance is used.
  /// If the given [npm] is `null`, the [NpmCommand] instance is used.
  DoctorCommand({
    FirebaseCommand firebase,
    GCloudCommand gcloud,
    GitCommand git,
    FlutterCommand flutter,
    NpmCommand npm,
  })  : _firebase = firebase ?? const FirebaseCommand(),
        _gcloud = gcloud ?? const GCloudCommand(),
        _git = git ?? const GitCommand(),
        _flutter = flutter ?? const FlutterCommand(),
        _npm = npm ?? const NpmCommand();

  @override
  Future<void> run() async {
    await _flutter.version();
    await _firebase.version();
    await _gcloud.version();
    await _git.version();
    await _npm.version();
  }
}
