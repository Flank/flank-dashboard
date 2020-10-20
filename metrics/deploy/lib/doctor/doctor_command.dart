import 'package:args/command_runner.dart';
import 'package:deploy/cli/firebase/firebase_command.dart';
import 'package:deploy/cli/flutter/flutter_command.dart';
import 'package:deploy/cli/gcloud/gcloud_command.dart';
import 'package:deploy/cli/git/git_command.dart';

/// A class providing doctor command to verify dependencies.
class DoctorCommand extends Command {
  @override
  final name = "doctor";
  @override
  final description = "Check dependencies.";

  /// Provides Firebase CLI.
  final _firebase = FirebaseCommand();

  /// Provides GCloud CLI.
  final _gcloud = GCloudCommand();

  /// Provides Git CLI.
  final _git = GitCommand();

  /// Provides Flutter CLI.
  final _flutter = FlutterCommand();

  /// Creates this doctor command instance.
  DoctorCommand();

  @override
  Future<void> run() async {
    await _flutter.version();
    await _firebase.version();
    await _gcloud.version();
    await _git.version();
  }
}
