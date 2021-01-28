import 'package:process_run/process_run.dart' as cmd;
import 'package:process_run/shell_run.dart';

/// A wrapper class for the Firebase CLI.
class FirebaseCommand {
  /// Logins to GCloud and Firebase and gets the Firebase CI token.
  Future<String> login() async {
    print('Firebase login.');
    await cmd.run(
      'firebase',
      ['login:ci', '--interactive'],
      verbose: true,
      stdin: sharedStdIn,
    );

    return prompt('Copy Firebase Token from above');
  }

  /// Adds Firebase capabilities to the project
  /// based on the given [projectId] and [firebaseToken].
  Future<void> addFirebase(String projectId, String firebaseToken) async {
    if (await promptConfirm('Add firebase capabilities to project?')) {
      print('Adding Firebase capabilities.');
      await cmd.run(
        'firebase',
        ['projects:addfirebase', projectId, '--token', firebaseToken],
        verbose: true,
        stdin: sharedStdIn,
      );
    } else {
      print('Skipping adding Firebase capabilities.');
    }
  }

  /// Creates Firebase web app with the given [projectId] and [firebaseToken].
  Future<void> createWebApp(String projectId, String firebaseToken) async {
    if (await promptConfirm('Add web app?')) {
      print('Adding Firebase web app.');
      await cmd.run(
        'firebase',
        [
          'apps:create',
          '--project',
          projectId,
          '--token',
          firebaseToken,
          "WEB",
          projectId
        ],
        verbose: true,
        stdin: sharedStdIn,
      );
    } else {
      print('Skipping adding web app.');
    }
  }

  /// Chooses the firebase project.
  Future<void> chooseProject(
    String projectId,
    String workingDir,
    String firebaseToken,
  ) async {
    await cmd.run(
      'firebase',
      [
        'use',
        '--add',
        projectId,
        '--token',
        firebaseToken,
      ],
      workingDirectory: workingDir,
      verbose: true,
      stdin: sharedStdIn,
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
      workingDirectory: workingDir,
      verbose: true,
      stdin: sharedStdIn,
    );
  }

  /// Applies the firebase target.
  Future<void> applyTarget(
    String projectId,
    String workingDir,
    String firebaseToken,
  ) async {
    await cmd.run(
      'firebase',
      [
        'target:apply',
        'hosting',
        'metrics',
        projectId,
        '--token',
        firebaseToken,
      ],
      workingDirectory: workingDir,
      verbose: true,
      stdin: sharedStdIn,
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
      workingDirectory: workingDir,
      verbose: true,
      stdin: sharedStdIn,
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
      workingDirectory: workingDir,
      verbose: true,
      stdin: sharedStdIn,
    );
  }

  /// Deploys functions to the firebase.
  Future<void> deployFunctions(String workingDir, String firebaseToken) async {
    await cmd.run(
      'firebase',
      [
        'deploy',
        '--only',
        'functions',
        '--token',
        firebaseToken,
      ],
      workingDirectory: workingDir,
      verbose: true,
      stdin: sharedStdIn,
    );
  }

  /// Prints CLI version.
  Future<void> version() async {
    await cmd.run('firebase', ['--version'], verbose: true, stdin: sharedStdIn);
  }
}
