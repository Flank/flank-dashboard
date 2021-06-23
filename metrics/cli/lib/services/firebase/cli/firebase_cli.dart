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
  Future<void> setFirebaseProject(
    String projectId,
    String workingDirectory, [
    String authToken,
  ]) {
    final parameters = ['use', projectId];

    if (authToken != null) parameters.add('--token=$authToken');

    return run(parameters, workingDirectory: workingDirectory);
  }

  /// Clears the Firebase [target] in the given [workingDirectory].
  Future<void> clearTarget(
    String target,
    String workingDirectory, [
    String authToken,
  ]) {
    final parameters = ['target:clear', 'hosting', target];

    if (authToken != null) parameters.add('--token=$authToken');

    return run(parameters, workingDirectory: workingDirectory);
  }

  /// Associates the Firebase [target] with the given [hostingName]
  /// in the given [workingDirectory].
  Future<void> applyTarget(
    String hostingName,
    String target,
    String workingDirectory, [
    String authToken,
  ]) {
    final parameters = ['target:apply', 'hosting', target, hostingName];

    if (authToken != null) parameters.add('--token=$authToken');

    return run(parameters, workingDirectory: workingDirectory);
  }

  /// Deploys a project's [target] from the given [workingDirectory]
  /// to the Firebase hosting.
  Future<void> deployHosting(
    String target,
    String workingDirectory, [
    String authToken,
  ]) {
    final parameters = ['deploy', '--only', 'hosting:$target'];

    if (authToken != null) parameters.add('--token=$authToken');

    return run(parameters, workingDirectory: workingDirectory);
  }

  /// Deploys Firestore rules and indexes from the given [workingDirectory]
  /// to the Firebase.
  Future<void> deployFirestore(String workingDirectory, [String authToken]) {
    final parameters = ['deploy', '--only', 'firestore'];

    if (authToken != null) parameters.add('--token=$authToken');

    return run(parameters, workingDirectory: workingDirectory);
  }

  /// Deploys functions from the given [workingDirectory] to the Firebase.
  Future<void> deployFunctions(String workingDirectory, [String authToken]) {
    final parameters = ['deploy', '--only', 'functions'];

    if (authToken != null) parameters.add('--token=$authToken');

    return run(parameters, workingDirectory: workingDirectory);
  }

  @override
  Future<void> version() {
    return run(['--version']);
  }
}
