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

  /// Adds Firebase capabilities to the project with the given [projectId].
  Future<void> addFirebase(String projectId) {
    return run(['projects:addfirebase', projectId]);
  }

  /// Creates Firebase web app with the given [projectId].
  Future<void> createWebApp(String projectId) {
    return run(['apps:create', '--project', projectId, "WEB", projectId]);
  }

  /// Sets [projectId] as the default project in the given [workingDirectory].
  Future<void> setFirebaseProject(String projectId, String workingDirectory) {
    return run(['use', projectId], workingDirectory: workingDirectory);
  }

  /// Clears the firebase [target] in the given [workingDirectory].
  Future<void> clearTarget(String target, String workingDirectory) {
    return run(
      ['target:clear', 'hosting', target],
      workingDirectory: workingDirectory,
    );
  }

  /// Associates the firebase [target] with the given [projectId]
  /// in the given [workingDirectory].
  Future<void> applyTarget(
    String projectId,
    String target,
    String workingDirectory,
  ) {
    return run(
      ['target:apply', 'hosting', target, projectId],
      workingDirectory: workingDirectory,
    );
  }

  /// Deploys a project with the associated [target]
  /// to the firebase hosting from the given [workingDirectory].
  Future<void> deployHosting(String target, String workingDirectory) {
    return run(
      ['deploy', '--only', 'hosting:$target'],
      workingDirectory: workingDirectory,
    );
  }

  /// Deploys a firestore rules to the firebase
  /// from the given [workingDirectory].
  Future<void> deployRules(String target, String workingDirectory) {
    return run(
      ['deploy', '--only', 'firestore:rules'],
      workingDirectory: workingDirectory,
    );
  }

  /// Deploys functions to the firebase from the given [workingDirectory].
  Future<void> deployFunctions(String workingDirectory) {
    return run(
      ['deploy', '--only', 'functions'],
      workingDirectory: workingDirectory,
    );
  }

  @override
  Future<void> version() {
    return run(['--version']);
  }
}
