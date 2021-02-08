// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:process_run/process_run.dart' as cmd;
import 'package:process_run/shell.dart';
import 'package:deploy/cli/firebase/firebase_command.dart';
import 'package:deploy/cli/gcloud/gcloud_command.dart';
import 'package:deploy/cli/git/git_command.dart';

/// class extending [Command] to facilitate  building GCloud project,build and deploy metrics app.
class DeployCommand extends Command {
  @override
  final name = "deploy";
  @override
  final description =
      "Creates GCloud and Firebase project and deploy metrics app.";

  final _firebase = FirebaseCommand();
  final _gcloud = GCloudCommand();
  final _git = GitCommand();
  static const _repoURL = 'git@github.com:platform-platform/monorepo.git';
  static const _srcPath = 'src';

  DeployCommand();

  @override
  Future<void> run() async {
    final _firebaseToken = await _login();

    final _projectID = await _gcloud.addProject();

    await _firebase.addFirebase(_projectID, _firebaseToken);

    final _region = await _selectRegion();

    await _gcloud.addProjectApp(_region, _projectID);

    await _gcloud.createDatabase(_region, _projectID);

    final _appID = await _firebase.createWebApp(_projectID, _firebaseToken);

    //final firebaseSrc = srcPath + '/metrics/firebase';
    await _buildAndDeploy(
        _appID, _projectID, _firebaseToken, _repoURL, _srcPath);
    // Cleanup
    await cleanup(_srcPath);
    // Terminate prompt entry.
    await promptTerminate();
  }

  /// Login to GCloud and Firebase and get firebase CI token
  Future<String> _login() async {
    await _gcloud.login();
    await _firebase.login();
    // Configure firebase project
    return prompt('Copy Firebase Token from above');
  }

  ///  Select GCP region
  Future<String> _selectRegion() async {
    // TODO: Listing regions won't work on new projects as compute API not enabled yet.
    //await run('gcloud',['compute','regions','list'],verbose:true);
    print('Select default region.');
    return prompt('region');
  }

  /// Git clone latest metrics code, build and deploy.
  Future<void> _buildAndDeploy(
    String appID,
    String projectID,
    String firebaseToken,
    String repoURL,
    String srcPath,
  ) async {
    final workingDir = '$srcPath/metrics/web';
    final configPath = '$workingDir/web/firebase-config.js';
    // git clone repo
    await _git.clone(repoURL, srcPath);
    // clean previouse config
    await cmd.run('rm', ['-rf', configPath], verbose: true);
    await _firebase.downloadSDKConfig(
        appID, configPath, projectID, firebaseToken);
    // add firebase project
    await cmd.run('firebase', ['use', '--add', projectID],
        workingDirectory: workingDir, verbose: true);
    // flutter build web --dart-define=FLUTTER_WEB_USE_SKIA=true
    await cmd.run('flutter', ['build', 'web'],
        workingDirectory: workingDir, verbose: true);
    // firebase deploy --only hosting
    await cmd.run('firebase', ['deploy', '--only', 'hosting'],
        workingDirectory: workingDir, verbose: true);
  }

  /// Cleanup resources.
  Future<void> cleanup(String srcPath) async {
    final configDirectory = Directory(srcPath);
    await configDirectory.delete(recursive: true);
  }
}
