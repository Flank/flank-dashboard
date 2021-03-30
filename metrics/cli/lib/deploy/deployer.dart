// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/cli/firebase/firebase_command.dart';
import 'package:cli/cli/git/git_command.dart';
import 'package:cli/common/model/services.dart';
import 'package:cli/deploy/constants/deploy_constants.dart';
import 'package:cli/flutter/service/flutter_service.dart';
import 'package:cli/gcloud/service/gcloud_service.dart';
import 'package:cli/helper/file_helper.dart';

/// A class providing method for deploying the Metrics Web Application.
class Deployer {
  /// A service that provides methods for working with Flutter.
  FlutterService _flutterService;

  /// A service that provides methods for working with GCloud.
  GCloudService _gcloudService;

  /// A class that provides methods for working with the file system.
  final FileHelper _fileHelper;

  /// A class that provides methods for working with the Firebase.
  final FirebaseCommand _firebaseCommand;

  /// A class that provides methods for working with the Git.
  final GitCommand _gitCommand;

  /// Creates a new instance of the [Deployer] with the given services.
  Deployer(
    Services services,
    this._firebaseCommand,
    this._gitCommand,
    this._fileHelper,
  ) {
    ArgumentError.checkNotNull(services, 'services');
    ArgumentError.checkNotNull(_firebaseCommand, 'firebaseCommand');
    ArgumentError.checkNotNull(_gitCommand, 'gitCommand');
    ArgumentError.checkNotNull(_fileHelper, 'fileHelper');

    _flutterService = services.flutterService;
    _gcloudService = services.gcloudService;
  }

  ///Deploys the Metrics Web Application.
  Future<void> deploy() async {
    await _gcloudService.login();

    final projectId = await _gcloudService.createProject();
    final firebaseToken = await _firebaseCommand.login();

    await _firebaseCommand.addFirebase(projectId, firebaseToken);
    await _firebaseCommand.createWebApp(projectId, firebaseToken);
    await _gitCommand.clone(DeployConstants.repoURL, DeployConstants.tempDir);
    await _flutterService.build(DeployConstants.webPath);
    await _firebaseCommand.setFirebaseProject(
      projectId,
      DeployConstants.webPath,
      firebaseToken,
    );
    await _firebaseCommand.applyTarget(
      projectId,
      DeployConstants.firebaseTarget,
      DeployConstants.webPath,
      firebaseToken,
    );
    await _firebaseCommand.deployHosting(
      DeployConstants.firebaseTarget,
      DeployConstants.webPath,
      firebaseToken,
    );

    final tempDirectory = _fileHelper.getDirectory(DeployConstants.tempDir);
    await tempDirectory.delete(recursive: true);
  }
}
