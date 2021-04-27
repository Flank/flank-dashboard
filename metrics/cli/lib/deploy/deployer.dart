// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/common/model/metrics_config.dart';
import 'package:cli/common/model/services.dart';
import 'package:cli/deploy/constants/deploy_constants.dart';
import 'package:cli/firebase/service/firebase_service.dart';
import 'package:cli/flutter/service/flutter_service.dart';
import 'package:cli/gcloud/service/gcloud_service.dart';
import 'package:cli/git/service/git_service.dart';
import 'package:cli/helper/file_helper.dart';
import 'package:cli/npm/service/npm_service.dart';
import 'package:clock/clock.dart';

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

  /// A class that provides methods for working with the [DateTime].
  final Clock _clock;

  /// Creates a new instance of the [Deployer] with the given services.
  ///
  /// Throws an [ArgumentError] if the given [services] is `null`.
  /// Throws an [ArgumentError] if the given [Services.flutterService] is `null`.
  /// Throws an [ArgumentError] if the given [Services.gcloudService] is `null`.
  /// Throws an [ArgumentError] if the given [Services.npmService] is `null`.
  /// Throws an [ArgumentError] if the given [Services.gitService] is `null`.
  /// Throws an [ArgumentError] if the given [Services.firebaseService] is `null`.
  /// Throws an [ArgumentError] if the given [fileHelper] is `null`.
  /// Throws an [ArgumentError] if the given [clock] is `null`.
  Deployer({
    Services services,
    FileHelper fileHelper,
    Clock clock,
  })  : _flutterService = services?.flutterService,
        _gcloudService = services?.gcloudService,
        _npmService = services?.npmService,
        _gitService = services?.gitService,
        _firebaseService = services?.firebaseService,
        _fileHelper = fileHelper,
        _clock = clock {
    ArgumentError.checkNotNull(services, 'services');
    ArgumentError.checkNotNull(_flutterService, 'flutterService');
    ArgumentError.checkNotNull(_gcloudService, 'gcloudService');
    ArgumentError.checkNotNull(_npmService, 'npmService');
    ArgumentError.checkNotNull(_gitService, 'gitService');
    ArgumentError.checkNotNull(_firebaseService, 'firebaseService');
    ArgumentError.checkNotNull(_fileHelper, 'fileHelper');
    ArgumentError.checkNotNull(_clock, 'clock');
  }

  /// Deploys the Metrics Web Application.
  Future<void> deploy() async {
    await _loginToServices();

    final projectId = await _gcloudService.createProject();

    await _firebaseService.createWebApp(projectId);

    final tempDirName = getTempDirectoryName();

    try {
      await _gitService.checkout(DeployConstants.repoURL, tempDirName);
      await _installNpmDependencies(tempDirName);
      await _flutterService.build(DeployConstants.webPath(tempDirName));
      await _firebaseService.upgradeBillingPlan(projectId);
      await _firebaseService.enableAnalytics(projectId);
      await _firebaseService.initializeFirestoreData(projectId);

      final googleClientId = await _firebaseService.configureAuthProviders(
        projectId,
      );
      final metricsConfig = MetricsConfig(googleSignInClientId: googleClientId);

      _applyMetricsConfig(metricsConfig, tempDirName);
      await _deployToFirebase(projectId, tempDirName);
    } finally {
      _cleanup(tempDirName);
    }
  }

  /// Generates a name of the temporary directory.
  String getTempDirectoryName() {
    final tempDirSuffix = _clock.now().millisecondsSinceEpoch.toString();

    return DeployConstants.tempDir(tempDirSuffix);
  }

  /// Logins to the necessary services.
  Future<void> _loginToServices() async {
    await _gcloudService.login();
    _gcloudService.acceptTermsOfService();

    await _firebaseService.login();
    _firebaseService.acceptTermsOfService();
  }

  /// Installs npm dependencies within the given [tempDirName].
  Future<void> _installNpmDependencies(String tempDirName) async {
    final firebasePath = DeployConstants.firebasePath(tempDirName);
    final firebaseFunctionsPath = DeployConstants.firebaseFunctionsPath(
      tempDirName,
    );

    await _npmService.installDependencies(firebasePath);
    await _npmService.installDependencies(firebaseFunctionsPath);
  }

  /// Deploys Firebase components and application to the Firebase project
  /// with the given [projectId] from the given [tempDirName].
  Future<void> _deployToFirebase(String projectId, String tempDirName) async {
    const target = DeployConstants.firebaseTarget;

    final firebasePath = DeployConstants.firebasePath(tempDirName);
    final webPath = DeployConstants.webPath(tempDirName);

    await _firebaseService.deployFirebase(projectId, firebasePath);
    await _firebaseService.deployHosting(projectId, target, webPath);
  }

  /// Applies the given [config] to the Metrics configuration file
  /// within the given [tempDirName].
  void _applyMetricsConfig(MetricsConfig config, String tempDirName) {
    final configPath = DeployConstants.metricsConfigPath(tempDirName);
    final configFile = _fileHelper.getFile(configPath);

    _fileHelper.replaceEnvironmentVariables(configFile, config.toMap());
  }

  /// Cleans temporary resources created during the deployment process.
  void _cleanup(String tempDirName) {
    final tempDirectory = _fileHelper.getDirectory(tempDirName);
    final directoryExist = tempDirectory.existsSync();

    if (!directoryExist) return;

    tempDirectory.deleteSync(recursive: true);
  }
}
