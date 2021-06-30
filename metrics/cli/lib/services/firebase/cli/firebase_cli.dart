// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/services/common/cli/cli.dart';

/// A class that represents the Firebase [Cli].
class FirebaseCli extends Cli {
  @override
  final String executable = 'firebase';

  /// Logins into the Firebase CLI.
  Future<void> login() {
    return run(['login', '--interactive', '--reauth']);
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
  ///
  /// Authenticates the firebase project setting process using the given
  /// [authToken] if it is not `null`. Otherwise, authenticates using
  /// the global Firebase user.
  Future<void> setFirebaseProject(
    String projectId,
    String workingDirectory, [
    String authToken,
  ]) {
    final arguments = ['use', projectId];

    _addAuthToken(arguments, authToken);

    return run(arguments, workingDirectory: workingDirectory);
  }

  /// Clears the Firebase [target] in the given [workingDirectory].
  Future<void> clearTarget(
    String target,
    String workingDirectory,
  ) {
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
  ///
  /// Authenticates the hosting deployment process using the given [authToken]
  /// if it is not `null`. Otherwise, authenticates using
  /// the global Firebase user.
  Future<void> deployHosting(
    String target,
    String workingDirectory, [
    String authToken,
  ]) {
    final arguments = ['deploy', '--only', 'hosting:$target'];

    _addAuthToken(arguments, authToken);

    return run(arguments, workingDirectory: workingDirectory);
  }

  /// Deploys Firestore rules and indexes from the given [workingDirectory]
  /// to the Firebase.
  ///
  /// Authenticates the Firestore deployment process using the given [authToken]
  /// if it is not `null`. Otherwise, authenticates using
  /// the global Firebase user.
  Future<void> deployFirestore(String workingDirectory, [String authToken]) {
    final arguments = ['deploy', '--only', 'firestore'];

    _addAuthToken(arguments, authToken);

    return run(arguments, workingDirectory: workingDirectory);
  }

  /// Deploys functions from the given [workingDirectory] to the Firebase.
  ///
  /// Authenticates the functions deployment process using the given [authToken]
  /// if it is not `null`. Otherwise, authenticates using
  /// the global Firebase user.
  Future<void> deployFunctions(String workingDirectory, [String authToken]) {
    final arguments = ['deploy', '--only', 'functions'];

    _addAuthToken(arguments, authToken);

    return run(arguments, workingDirectory: workingDirectory);
  }

  @override
  Future<void> version() {
    return run(['--version']);
  }

  /// Adds a token argument to the [arguments] list
  /// if the given [authToken] is not `null`.
  void _addAuthToken(List<String> arguments, String authToken) {
    if (authToken != null) arguments.add('--token=$authToken');
  }
}
