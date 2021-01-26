import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:deploy/cli/firebase/firebase_command.dart';
import 'package:deploy/cli/flutter/flutter_command.dart';
import 'package:deploy/cli/gcloud/gcloud_command.dart';
import 'package:deploy/cli/git/git_command.dart';
import 'package:deploy/cli/npm/npm_command.dart';
import 'package:process_run/shell.dart';

/// A [Command] implementation that deploys the metrics app.
class DeployCommand extends Command {
  static const String _repoURL =
      'git@github.com:platform-platform/monorepo.git';
  static const String _tempDir = 'tempDir';
  static const String _webPath = '$_tempDir/metrics/web';
  static const String _firebasePath = '$_tempDir/metrics/firebase';
  static const String _firebaseFunctionsPath = '$_firebasePath/functions';

  @override
  final String name = "deploy";

  @override
  final String description =
      "Creates GCloud and Firebase project and deploy metrics app.";

  /// A [FirebaseCommand] needed to get the Firebase CLI version.
  final FirebaseCommand _firebase = FirebaseCommand();

  /// A [GCloudCommand] needed to get the GCloud CLI version.
  final GCloudCommand _gcloud = GCloudCommand();

  /// A [GitCommand] needed to get the Git CLI version.
  final GitCommand _git = GitCommand();

  /// A [FlutterCommand] needed to get the Flutter CLI version.
  final FlutterCommand _flutter = FlutterCommand();

  /// A [NpmCommand] needed to get the Npm CLI version.
  final NpmCommand _npm = NpmCommand();

  @override
  Future<void> run() async {
    await _gcloud.login();
    final _projectID = await _gcloud.addProject();
    final _region = await _selectRegion();
    await _gcloud.addProjectApp(_region, _projectID);
    await _gcloud.createDatabase(_region, _projectID);

    final _firebaseToken = await _firebase.login();
    await _firebase.addFirebase(_projectID, _firebaseToken);
    await _firebase.createWebApp(_projectID, _firebaseToken);

    await _deploy(_projectID, _firebaseToken);

    await promptTerminate();
  }

  /// Selects a GCP region.
  Future<String> _selectRegion() async {
    // TODO: Listing regions won't work on new projects as compute API not enabled yet.
    //await run('gcloud',['compute','regions','list'],verbose:true);
    print('Select default region.');
    return prompt('region');
  }

  /// Deploys the metrics project to the firebase.
  Future<void> _deploy(
    String projectId,
    String firebaseToken,
  ) async {
    try {
      await _git.clone(_repoURL, _tempDir);

      await _firebase.chooseProject(projectId, _webPath, firebaseToken);
      await _flutter.buildWeb(_webPath);
      await _firebase.clearTarget(_webPath, firebaseToken);
      await _firebase.applyTarget(projectId, _webPath, firebaseToken);
      await _firebase.deployHosting(_webPath, firebaseToken);

      await _firebase.chooseProject(projectId, _firebasePath, firebaseToken);
      await _npm.install(_firebasePath);
      await _firebase.deployFirestore(_firebasePath, firebaseToken);

      final proceed = await promptConfirm(
        'A Blaze billing account is required for function deployment. '
        'Please go to the firebase console and enable it manually or '
        'skip this step.',
      );

      if (proceed) {
        await _npm.install(_firebaseFunctionsPath);
        await _firebase.deployFunctions(_firebasePath, firebaseToken);
      }
    } catch (error) {
      print(error);
    } finally {
      await _cleanup(_tempDir);
    }
  }

  /// Cleanups the directory by the given [path].
  Future<void> _cleanup(String path) async {
    final configDirectory = Directory(path);
    try {
      await configDirectory.delete(recursive: true);
    } catch (e) {
      print(e);
    }
  }
}
