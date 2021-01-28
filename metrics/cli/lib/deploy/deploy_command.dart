import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:cli/cli/firebase/firebase_command.dart';
import 'package:cli/cli/flutter/flutter_command.dart';
import 'package:cli/cli/gcloud/gcloud_command.dart';
import 'package:cli/cli/git/git_command.dart';
import 'package:cli/cli/npm/npm_command.dart';
import 'package:cli/constants/config_constants.dart';
import 'package:cli/strings/prompt_strings.dart';
import 'package:cli/util/file_helper.dart';
import 'package:cli/util/prompt_util.dart';

/// A [Command] implementation that deploys the metrics app.
class DeployCommand extends Command<void> {
  @override
  final String name = "deploy";

  @override
  final String description =
      "Creates GCloud and Firebase project and deploy metrics app.";

  /// A [FirebaseCommand] needed to get the Firebase CLI version.
  final FirebaseCommand _firebase;

  /// A [GCloudCommand] needed to get the GCloud CLI version.
  final GCloudCommand _gcloud;

  /// A [GitCommand] needed to get the Git CLI version.
  final GitCommand _git;

  /// A [FlutterCommand] needed to get the Flutter CLI version.
  final FlutterCommand _flutter;

  /// A [NpmCommand] needed to get the Npm CLI version.
  final NpmCommand _npm;

  final FileHelper _fileHelper;

  /// Creates an instance of the [DeployCommand].
  DeployCommand(
    this._firebase,
    this._gcloud,
    this._git,
    this._flutter,
    this._npm, [
    FileHelper _fileHelper,
  ]) : _fileHelper = _fileHelper ?? FileHelper();

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

    await PromptUtil.promptTerminate();
  }

  /// Selects a GCP region.
  Future<String> _selectRegion() async {
    // TODO: Listing regions won't work on new projects as compute API not enabled yet.
    //await run('gcloud',['compute','regions','list'],verbose:true);
    return PromptUtil.prompt(PromptStrings.selectRegion);
  }

  /// Deploys the metrics project to the firebase.
  Future<void> _deploy(
    String projectId,
    String firebaseToken,
  ) async {
    const repoURL = ConfigConstants.repoURL;
    const tempDir = ConfigConstants.tempDir;
    const webPath = ConfigConstants.webPath;
    const firebasePath = ConfigConstants.firebasePath;
    const functionsPath = ConfigConstants.firebaseFunctionsPath;

    try {
      await _git.clone(repoURL, tempDir);

      await _firebase.chooseProject(projectId, webPath, firebaseToken);
      await _flutter.buildWeb(webPath);
      await _firebase.clearTarget(webPath, firebaseToken);
      await _firebase.applyTarget(projectId, webPath, firebaseToken);
      await PromptUtil.prompt(PromptStrings.enableAnalytics);
      await _firebase.deployHosting(webPath, firebaseToken);

      await _firebase.chooseProject(projectId, firebasePath, firebaseToken);
      await _npm.install(firebasePath);
      await _firebase.deployFirestore(firebasePath, firebaseToken);

      final proceed =
          await PromptUtil.promptConfirm(PromptStrings.enableBillingAccount);

      if (proceed) {
        await _npm.install(functionsPath);
        await _firebase.deployFunctions(firebasePath, firebaseToken);
      } else {
        print('Skipping functions deploying.');
      }
    } catch (error) {
      print(error);
    } finally {
      await _fileHelper.deleteDirectory(Directory(tempDir));
    }
  }

  /// Deletes the given [Directory].
  Future<void> deleteDirectory(Directory directory) async {
    try {
      await directory.delete(recursive: true);
    } catch (error) {
      print(error);
    }
  }
}
