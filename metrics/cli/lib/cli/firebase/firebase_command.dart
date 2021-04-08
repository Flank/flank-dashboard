// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:process_run/process_run.dart' as cmd;
import 'package:process_run/shell.dart';

/// A wrapper class for the Firebase CLI.
class FirebaseCommand {
  /// Logins to GCloud and Firebase and gets the Firebase CI token.
  Future<String> login() async {
    // Logins to Firebase.
    print('Firebase login.');
    await cmd.runExecutableArguments(
      'firebase',
      ['login:ci', '--interactive'],
      verbose: true,
    );
    // Configures firebase project.
    return prompt('Copy Firebase Token from above');
  }

  /// Adds Firebase capabilities to the project
  /// based on the given [projectID] and [firebaseToken].
  Future<void> addFirebase(String projectID, String firebaseToken) async {
    if (await promptConfirm('Add firebase capabilities to project ?')) {
      print('Adding Firebase capabilities.');
      await cmd.runExecutableArguments(
        'firebase',
        ['projects:addfirebase', projectID, '--token', firebaseToken],
        verbose: true,
      );
    } else {
      print('Skipping adding Firebase capabilities.');
    }
  }

  /// Creates Firebase web app with the given [projectID] and [firebaseToken].
  Future<String> createWebApp(String projectID, String firebaseToken) async {
    //firebase apps:create --project $projectID
    if (await promptConfirm('Add web app?')) {
      print('Adding Firebase web app.');
      await cmd.runExecutableArguments(
        'firebase',
        [
          'apps:create',
          '--project',
          projectID,
          '--token',
          firebaseToken,
          "WEB",
          projectID
        ],
        verbose: true,
      );
    } else {
      print('List existings apps.');
      await cmd.runExecutableArguments(
        'firebase',
        ['apps:list', '--project', projectID, '--token', firebaseToken],
        verbose: true,
      );
    }
    print('Select appID.');
    return prompt('appID');
  }

  /// Downloads and writes web app SDK config to firebase-config.js file.
  Future<void> downloadSDKConfig(String appID, String configPath,
      String projectID, String firebaseToken) async {
    // Gets config.
    print('Write web app SDK config to firebase-config.js file.');
    await cmd.runExecutableArguments(
      'firebase',
      [
        'apps:sdkconfig',
        '-i',
        'WEB',
        appID,
        '--interactive',
        '--out',
        configPath,
        '--project',
        projectID,
        '--token',
        firebaseToken
      ],
      verbose: true,
    );
  }

  /// Sets the project with the [projectId] identifier as the default one
  /// for the Firebase project in the [workingDirectory].
  Future<void> setFirebaseProject(
    String projectId,
    String workingDirectory,
    String firebaseToken,
  ) async {
    await cmd.runExecutableArguments(
      'firebase',
      ['use', '--add', projectId, '--token', firebaseToken],
      workingDirectory: workingDirectory,
      verbose: true,
    );
  }

  /// Deploys a project's [target] from the given [workingDirectory]
  /// to the Firebase hosting.
  Future<void> deployHosting(
      String target, String workingDirectory, String firebaseToken) async {
    await cmd.runExecutableArguments(
      'firebase',
      ['deploy', '--only', 'hosting:$target', '--token', firebaseToken],
      workingDirectory: workingDirectory,
      verbose: true,
    );
  }

  /// Associates the firebase [target] with the given [hostingName]
  /// in the given [workingDirectory].
  Future<void> applyTarget(String hostingName, String target,
      String workingDirectory, String firebaseToken) {
    return cmd.runExecutableArguments(
      'firebase',
      [
        'target:apply',
        'hosting',
        target,
        hostingName,
        '--token',
        firebaseToken,
      ],
      workingDirectory: workingDirectory,
      verbose: true,
    );
  }

  /// Prints CLI version.
  Future<void> version() async {
    await cmd.runExecutableArguments('firebase', ['--version'], verbose: true);
  }
}
