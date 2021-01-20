import 'package:process_run/process_run.dart' as cmd;
import 'package:process_run/shell.dart';

/// A wrapper class for the Firebase CLI.
class FirebaseCommand {
  /// Logins to GCloud and Firebase and gets the Firebase CI token.
  Future<String> login() async {
    // Logins to Firebase.
    print('Firebase login.');
    await cmd.run('firebase', ['login:ci', '--interactive'], verbose: true);
    // Configures firebase project.
    return prompt('Copy Firebase Token from above');
  }

  /// Adds Firebase capabilities to the project
  /// based on the given [projectID] and [firebaseToken].
  Future<void> addFirebase(String projectID, String firebaseToken) async {
    if (await promptConfirm('Add firebase capabilities to project ?')) {
      print('Adding Firebase capabilities.');
      await cmd.run('firebase',
          ['projects:addfirebase', projectID, '--token', firebaseToken],
          verbose: true);
    } else {
      print('Skipping adding Firebase capabilities.');
    }
  }

  /// Creates Firebase web app with the given [projectID] and [firebaseToken].
  Future<String> createWebApp(String projectID, String firebaseToken) async {
    //firebase apps:create --project $projectID
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
          verbose: true);
    } else {
      print('List existings apps.');
      await cmd.run('firebase',
          ['apps:list', '--project', projectID, '--token', firebaseToken],
          verbose: true);
    }
    print('Select appID.');
    return prompt('appID');
  }

  /// Downloads and writes web app SDK config to firebase-config.js file.
  Future<void> downloadSDKConfig(String appID, String configPath,
      String projectID, String firebaseToken) async {
    // Gets config.
    print('Write web app SDK config to firebase-config.js file.');
    await cmd.run(
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
        verbose: true);
  }

  /// Chooses the firebase project.
  Future<void> chooseProject(String projectID, String workingDir) async {
    await cmd.run('firebase', ['use', '--add', projectID],
        workingDirectory: workingDir, verbose: true);
  }

  /// Deploys project to the firebase hosting.
  Future<void> deployHosting(String workingDir) async {
    await cmd.run('firebase', ['deploy', '--only', 'hosting'],
        workingDirectory: workingDir, verbose: true);
  }

  /// Deploys code and assets to the firebase.
  Future<void> deploy(String workingDir) async {
    await cmd.run('firebase', ['deploy'],
        workingDirectory: workingDir, verbose: true);
  }

  /// Prints CLI version.
  Future<void> version() async {
    await cmd.run('firebase', ['--version'], verbose: true);
  }
}
