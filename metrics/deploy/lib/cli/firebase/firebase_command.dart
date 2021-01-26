import 'dart:io';

import 'package:process_run/process_run.dart' as cmd;
import 'package:process_run/shell.dart';

/// A wrapper class for the Firebase CLI.
class FirebaseCommand {
  /// Logins to GCloud and Firebase and gets the Firebase CI token.
  Future<String> login() async {
    print('Firebase login.');
    await cmd.run(
      'firebase',
      ['login:ci', '--interactive'],
      stdin: stdin,
      verbose: true,
    );

    return prompt('Copy Firebase Token from above');
  }

  /// Adds Firebase capabilities to the project
  /// based on the given [projectID] and [firebaseToken].
  Future<void> addFirebase(String projectID, String firebaseToken) async {
    if (await promptConfirm('Add firebase capabilities to project?')) {
      print('Adding Firebase capabilities.');
      await cmd.run(
        'firebase',
        ['projects:addfirebase', projectID, '--token', firebaseToken],
        stdin: stdin,
        verbose: true,
      );
    } else {
      print('Skipping adding Firebase capabilities.');
    }
  }

  /// Creates Firebase web app with the given [projectID] and [firebaseToken].
  Future<void> createWebApp(String projectID, String firebaseToken) async {
    if (await promptConfirm('Add web app?')) {
      print('Adding Firebase web app.');
      await cmd.run(
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
        stdin: stdin,
        verbose: true,
      );
    } else {
      print('List of existing apps.');
      await cmd.run(
        'firebase',
        ['apps:list', '--project', projectID, '--token', firebaseToken],
        stdin: stdin,
        verbose: true,
      );
    }
  }

  /// Chooses the firebase project.
  Future<void> chooseProject(
    String projectID,
    String workingDir,
    String firebaseToken,
  ) async {
    await cmd.run(
      'firebase',
      [
        'use',
        '--add',
        projectID,
        '--token',
        firebaseToken,
      ],
      stdin: stdin,
      workingDirectory: workingDir,
      verbose: true,
    );
  }

  /// Clears the firebase target.
  Future<void> clearTarget(String workingDir, String firebaseToken) async {
    await cmd.run(
      'firebase',
      [
        'target:clear',
        'hosting',
        'metrics',
        '--token',
        firebaseToken,
      ],
      stdin: stdin,
      workingDirectory: workingDir,
      verbose: true,
    );
  }

  /// Applies the firebase target.
  Future<void> applyTarget(
    String projectName,
    String workingDir,
    String firebaseToken,
  ) async {
    await cmd.run(
      'firebase',
      [
        'target:apply',
        'hosting',
        'metrics',
        projectName,
        '--token',
        firebaseToken,
      ],
      stdin: stdin,
      workingDirectory: workingDir,
      verbose: true,
    );
  }

  /// Deploys a project to the firebase hosting.
  Future<void> deployHosting(String workingDir, String firebaseToken) async {
    await cmd.run(
      'firebase',
      [
        'deploy',
        '--only',
        'hosting:metrics',
        '--token',
        firebaseToken,
      ],
      stdin: stdin,
      workingDirectory: workingDir,
      verbose: true,
    );
  }

  /// Deploys a firestore settings to the firebase.
  Future<void> deployFirestore(String workingDir, String firebaseToken) async {
    await cmd.run(
      'firebase',
      [
        'deploy',
        '--only',
        'firestore',
        '--token',
        firebaseToken,
      ],
      stdin: stdin,
      workingDirectory: workingDir,
      verbose: true,
    );
  }

  /// Deploys functions to the firebase.
  Future<void> deployFunctions(String workingDir, String firebaseToken) async {
    final proceed = await promptConfirm(
      'A Blaze billing account is required for function deployment. '
      'Please go to the firebase console and enable it manually or '
      'skip this step.',
    );

    if (proceed) {
      await cmd.run(
        'firebase',
        [
          'deploy',
          '--only',
          'functions',
          '--token',
          firebaseToken,
        ],
        stdin: stdin,
        workingDirectory: workingDir,
        verbose: true,
      );
    }
  }

  /// Prints CLI version.
  Future<void> version() async {
    await cmd.run('firebase', ['--version'], stdin: stdin, verbose: true);
  }
}
