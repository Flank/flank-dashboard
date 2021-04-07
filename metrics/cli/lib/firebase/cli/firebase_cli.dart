// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/interfaces/cli/cli.dart';

/// A class that represents the Firebase [Cli].
class FirebaseCli extends Cli {
  @override
  final String executable = 'firebase';

  /// Logins into the Firebase CLI.
  Future<void> login() {
    return run(['login', '--interactive']);
  }

  /// Adds the Firebase capabilities to the project with the given [projectId].
  Future<void> addFirebase(String projectId) {
    return run(['projects:addfirebase', projectId]);
  }

  /// Creates a Firebase web app with the given [appName]
  /// within the project with the given [projectId].
  Future<void> createWebApp(String projectId, String appName) {
    return run(['apps:create', '--project', projectId, "WEB", appName]);
  }

  /// Sets the project with the [projectId] identifier as the default one
  /// for the Firebase project in the [workingDirectory].
  Future<void> setFirebaseProject(String projectId, String workingDirectory) {
    return run(['use', projectId], workingDirectory: workingDirectory);
  }

  /// Clears the Firebase [target] in the given [workingDirectory].
  Future<void> clearTarget(String target, String workingDirectory) {
    return run(
      ['target:clear', 'hosting', target],
      workingDirectory: workingDirectory,
    );
  }

  /// Associates the Firebase [target] with the given [hostingName]
  /// in the given [workingDirectory].
  Future<void> applyTarget(
    String hostingName,
    String target,
    String workingDirectory,
  ) {
    return run(
      ['target:apply', 'hosting', target, hostingName],
      workingDirectory: workingDirectory,
    );
  }

  /// Deploys a project's [target] from the given [workingDirectory]
  /// to the Firebase hosting.
  Future<void> deployHosting(String target, String workingDirectory) {
    return run(
      ['deploy', '--only', 'hosting:$target'],
      workingDirectory: workingDirectory,
    );
  }

  /// Deploys Firestore rules from the given [workingDirectory] to the Firebase.
  Future<void> deployRules(String target, String workingDirectory) {
    return run(
      ['deploy', '--only', 'firestore:rules'],
      workingDirectory: workingDirectory,
    );
  }

  /// Deploys functions from the given [workingDirectory] to the Firebase.
  Future<void> deployFunctions(String workingDirectory) {
    return run(
      ['deploy', '--only', 'functions'],
      workingDirectory: workingDirectory,
    );
  }

  @override
  Future<void> version() async {
    return run(['--version']);
  }
}
