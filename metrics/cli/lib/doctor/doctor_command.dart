// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:args/command_runner.dart';
import 'package:deploy/cli/firebase/firebase_command.dart';
import 'package:deploy/cli/flutter/flutter_command.dart';
import 'package:deploy/cli/gcloud/gcloud_command.dart';
import 'package:deploy/cli/git/git_command.dart';

/// A class providing doctor command to verify dependencies.
class DoctorCommand extends Command {
  @override
  final String name = "doctor";

  @override
  final String description = "Check dependencies.";

  /// A [FirebaseCommand] needed to get the Firebase CLI version.
  final FirebaseCommand _firebase = FirebaseCommand();

  /// A [GCloudCommand] needed to get the GCloud CLI version.
  final GCloudCommand _gcloud = GCloudCommand();

  /// A [GitCommand] needed to get the Git CLI version.
  final GitCommand _git = GitCommand();

  /// A [FlutterCommand] needed to get the Flutter CLI version.
  final FlutterCommand _flutter = FlutterCommand();

  @override
  Future<void> run() async {
    await _flutter.version();
    await _firebase.version();
    await _gcloud.version();
    await _git.version();
  }
}
