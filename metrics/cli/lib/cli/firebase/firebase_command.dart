import 'package:cli/strings/prompt_strings.dart';
import 'package:cli/util/prompt_util.dart';
import 'package:process_run/process_run.dart' as cmd;
import 'package:process_run/shell_run.dart';

/// A wrapper class for the Firebase CLI.
class FirebaseCommand {
  /// Creates a new instance of the [FirebaseCommand].
  const FirebaseCommand();

  /// Logins into the Firebase.
  Future<String> login() async {
    print('Firebase login.');
    await cmd.run(
      'firebase',
      ['login:ci', '--interactive'],
      verbose: true,
      stdin: sharedStdIn,
    );

    return PromptUtil.prompt(PromptStrings.firebaseToken);
  }

  /// Adds Firebase capabilities to the project
  /// based on the given [projectId] and [firebaseToken].
  Future<void> addFirebase(String projectId, String firebaseToken) async {
    final addCapabilities =
        await PromptUtil.promptConfirm(PromptStrings.addFirebaseCapabilities);

    if (addCapabilities) {
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

  /// Creates Firebase web app for the given [projectId] and [firebaseToken].
  Future<void> createWebApp(String projectId, String firebaseToken) async {
    final addWebApp = await PromptUtil.promptConfirm(PromptStrings.addWebApp);

    if (addWebApp) {
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

  /// Initializes the firebase project into the given [workingDir] for
  /// the given [projectId] and [firebaseToken].
  Future<void> initFirebaseProject(
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

  /// Clears the firebase target in the given [workingDir] for
  /// the given [firebaseToken].
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

  /// Applies the firebase target into the given [workingDir] for
  /// the given [projectId] and [firebaseToken].
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

  /// Deploys a project from the given [workingDir] to the firebase hosting
  /// using the given [firebaseToken].
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

  /// Deploys a firestore settings from the given [workingDir] to the firebase
  /// using the given [firebaseToken].
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

  /// Deploys functions from the given [workingDir] to the firebase
  /// using the given [firebaseToken].
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
