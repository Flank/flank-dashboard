// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/common/model/metrics_config.dart';
import 'package:cli/common/model/services.dart';
import 'package:cli/deploy/constants/deploy_constants.dart';
import 'package:cli/deploy/strings/deploy_strings.dart';
import 'package:cli/firebase/service/firebase_service.dart';
import 'package:cli/flutter/service/flutter_service.dart';
import 'package:cli/gcloud/service/gcloud_service.dart';
import 'package:cli/git/service/git_service.dart';
import 'package:cli/helper/file_helper.dart';
import 'package:cli/npm/service/npm_service.dart';
import 'package:cli/prompt/prompter.dart';
import 'package:cli/sentry/model/sentry_release.dart';
import 'package:cli/sentry/model/source_map.dart';
import 'package:cli/sentry/service/sentry_service.dart';

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

  /// A class that provides methods for working with the Sentry.
  final SentryService _sentryService;

  /// A class that provides methods for working with the file system.
  final FileHelper _fileHelper;

  /// A [Prompter] class this adapter uses to interact with a user.
  final Prompter _prompter;

  /// Creates a new instance of the [Deployer] with the given services.
  ///
  /// Throws an [ArgumentError] if the given [services] is `null`.
  /// Throws an [ArgumentError] if the given [Services.flutterService] is `null`.
  /// Throws an [ArgumentError] if the given [Services.gcloudService] is `null`.
  /// Throws an [ArgumentError] if the given [Services.npmService] is `null`.
  /// Throws an [ArgumentError] if the given [Services.gitService] is `null`.
  /// Throws an [ArgumentError] if the given [Services.firebaseService] is `null`.
  /// Throws an [ArgumentError] if the given [Services.sentryService] is `null`.
  /// Throws an [ArgumentError] if the given [fileHelper] is `null`.
  /// Throws an [ArgumentError] if the given [prompter] is `null`.
  Deployer({
    Services services,
    FileHelper fileHelper,
    Prompter prompter,
  })  : _flutterService = services?.flutterService,
        _gcloudService = services?.gcloudService,
        _npmService = services?.npmService,
        _gitService = services?.gitService,
        _firebaseService = services?.firebaseService,
        _sentryService = services?.sentryService,
        _fileHelper = fileHelper,
        _prompter = prompter {
    ArgumentError.checkNotNull(services, 'services');
    ArgumentError.checkNotNull(_flutterService, 'flutterService');
    ArgumentError.checkNotNull(_gcloudService, 'gcloudService');
    ArgumentError.checkNotNull(_npmService, 'npmService');
    ArgumentError.checkNotNull(_gitService, 'gitService');
    ArgumentError.checkNotNull(_firebaseService, 'firebaseService');
    ArgumentError.checkNotNull(_fileHelper, 'fileHelper');
    ArgumentError.checkNotNull(_prompter, 'prompter');
  }

  /// Deploys the Metrics Web Application.
  Future<void> deploy() async {
    await _loginToServices();

    final projectId = await _gcloudService.createProject();

    await _firebaseService.createWebApp(projectId);

    try {
      await _gitService.checkout(
        DeployConstants.repoURL,
        DeployConstants.tempDir,
      );
      await _installNpmDependencies();
      await _flutterService.build(DeployConstants.webPath);
      await _firebaseService.upgradeBillingPlan(projectId);
      await _firebaseService.enableAnalytics(projectId);
      await _firebaseService.initializeFirestoreData(projectId);

      final googleClientId = await _firebaseService.configureAuthProviders(
        projectId,
      );
      final sentryRelease = await _setupSentry();
      final sentryDsn = _getSentryDsn(sentryRelease);

      final metricsConfig = MetricsConfig(
        googleSignInClientId: googleClientId,
        sentryRelease: sentryRelease?.name,
        sentryDsn: sentryDsn,
      );

      _applyMetricsConfig(metricsConfig);
      await _deployToFirebase(projectId);
    } finally {
      _cleanup();
    }
  }

  /// Logins to the necessary services.
  Future<void> _loginToServices() async {
    await _gcloudService.login();
    await _firebaseService.login();
    _firebaseService.acceptTermsOfService();
  }

  /// Installs npm dependencies.
  Future<void> _installNpmDependencies() async {
    await _npmService.installDependencies(DeployConstants.firebasePath);
    await _npmService.installDependencies(
      DeployConstants.firebaseFunctionsPath,
    );
  }

  /// Configures the Sentry environment.
  Future<SentryRelease> _setupSentry() async {
    final sentryRequired = _prompter.promptConfirm(DeployStrings.setupSentry);

    if (!sentryRequired) return null;

    final webSourceMap = SourceMap(
      path: DeployConstants.webPath,
      extensions: const ['dart'],
    );

    final buildSourceMap = SourceMap(
      path: DeployConstants.buildPath,
      extensions: const ['dart'],
    );

    await _sentryService.login();

    return _sentryService.createRelease([webSourceMap, buildSourceMap]);
  }

  /// Returns the Sentry DSN based on the given [release].
  String _getSentryDsn(SentryRelease release) {
    if (release == null) return null;

    return _sentryService.getProjectDsn(release.project);
  }

  /// Deploys Firebase components and application to the Firebase project
  /// with the given [projectId].
  Future<void> _deployToFirebase(String projectId) async {
    await _firebaseService.deployFirebase(
      projectId,
      DeployConstants.firebasePath,
    );
    await _firebaseService.deployHosting(
      projectId,
      DeployConstants.firebaseTarget,
      DeployConstants.webPath,
    );
  }

  /// Applies the given [config] to the Metrics configuration file.
  void _applyMetricsConfig(MetricsConfig config) {
    final configFile = _fileHelper.getFile(DeployConstants.metricsConfigPath);

    _fileHelper.replaceEnvironmentVariables(configFile, config.toMap());
  }

  /// Cleans temporary resources created during the deployment process.
  void _cleanup() {
    final tempDirectory = _fileHelper.getDirectory(DeployConstants.tempDir);
    final directoryExist = tempDirectory.existsSync();

    if (!directoryExist) return;

    tempDirectory.deleteSync(recursive: true);
  }
}
