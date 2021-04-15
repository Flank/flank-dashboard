// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/common/model/services.dart';
import 'package:cli/deploy/constants/deploy_constants.dart';
import 'package:cli/firebase/service/firebase_service.dart';
import 'package:cli/flutter/service/flutter_service.dart';
import 'package:cli/gcloud/service/gcloud_service.dart';
import 'package:cli/git/service/git_service.dart';
import 'package:cli/helper/file_helper.dart';
import 'package:cli/npm/service/npm_service.dart';

/// A class providing method for deploying the Metrics Web Application.
class Deployer {
  /// A service that provides methods for working with Flutter.
  final FlutterService _flutterService;

  /// A service that provides methods for working with GCloud.
  final GCloudService _gcloudService;

  /// A service that provides methods for working with Npm.
  final NpmService _npmService;

  /// A class that provides methods for working with the Git.
  final GitService _gitService;

  /// A class that provides methods for working with the Firebase.
  final FirebaseService _firebaseService;

  /// A class that provides methods for working with the file system.
  final FileHelper _fileHelper;

  /// Creates a new instance of the [Deployer] with the given services.
  ///
  /// Throws an [ArgumentError] if the given [services] is `null`.
  /// Throws an [ArgumentError] if the given [Services.flutterService] is `null`.
  /// Throws an [ArgumentError] if the given [Services.gcloudService] is `null`.
  /// Throws an [ArgumentError] if the given [Services.npmService] is `null`.
  /// Throws an [ArgumentError] if the given [Services.gitService] is `null`.
  /// Throws an [ArgumentError] if the given [Services.firebaseService] is `null`.
  /// Throws an [ArgumentError] if the given [fileHelper] is `null`.
  Deployer({
    Services services,
    FileHelper fileHelper,
  })  : _flutterService = services?.flutterService,
        _gcloudService = services?.gcloudService,
        _npmService = services?.npmService,
        _gitService = services?.gitService,
        _firebaseService = services?.firebaseService,
        _fileHelper = fileHelper {
    ArgumentError.checkNotNull(services, 'services');
    ArgumentError.checkNotNull(_flutterService, 'flutterService');
    ArgumentError.checkNotNull(_gcloudService, 'gcloudService');
    ArgumentError.checkNotNull(_npmService, 'npmService');
    ArgumentError.checkNotNull(_gitService, 'gitService');
    ArgumentError.checkNotNull(_firebaseService, 'firebaseService');
    ArgumentError.checkNotNull(_fileHelper, 'fileHelper');
  }

  /// Deploys the Metrics Web Application.
  Future<void> deploy() async {
    final projectId = await _createGcloudProject();

    await _createFirebaseApp(projectId);
    await _gitService.checkout(
      DeployConstants.repoURL,
      DeployConstants.tempDir,
    );
    await _deployFirebase(projectId);
    await _deployHosting(projectId);
    await _clearResources();
  }

  Future<String> _createGcloudProject() async {
    await _gcloudService.login();

    return _gcloudService.createProject();
  }

  Future<void> _createFirebaseApp(String projectId) async {
    await _firebaseService.login();
    await _firebaseService.createWebApp(projectId);
  }

  Future<void> _deployFirebase(String projectId) async {
    const firebasePath = DeployConstants.firebasePath;

    await _npmService.installDependencies(firebasePath);
    await _npmService.installDependencies(
      DeployConstants.firebaseFunctionsPath,
    );
    await _firebaseService.deployFirebase(projectId, firebasePath);
  }

  Future<void> _deployHosting(String projectId) async {
    const webAppPath = DeployConstants.webPath;

    await _flutterService.build(webAppPath);
    await _firebaseService.deployHosting(
      projectId,
      DeployConstants.firebaseTarget,
      webAppPath,
    );
  }

  Future<void> _clearResources() async {
    final tempDirectory = _fileHelper.getDirectory(DeployConstants.tempDir);
    await tempDirectory.delete(recursive: true);
  }
}
