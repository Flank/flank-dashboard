// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:cli/common/model/services.dart';
import 'package:cli/common/model/web_metrics_config.dart';
import 'package:cli/deploy/constants/deploy_constants.dart';
import 'package:cli/deploy/factory/deploy_paths_factory.dart';
import 'package:cli/deploy/model/deploy_paths.dart';
import 'package:cli/deploy/strings/deploy_strings.dart';
import 'package:cli/firebase/service/firebase_service.dart';
import 'package:cli/flutter/service/flutter_service.dart';
import 'package:cli/gcloud/service/gcloud_service.dart';
import 'package:cli/git/service/git_service.dart';
import 'package:cli/helper/file_helper.dart';
import 'package:cli/npm/service/npm_service.dart';
import 'package:cli/prompt/prompter.dart';
import 'package:cli/sentry/model/sentry_config.dart';
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

  /// A [Prompter] class this deployer uses to interact with a user.
  final Prompter _prompter;

  /// A [DeployPathsFactory] class uses to create the [DeployPaths].
  final DeployPathsFactory _deployPathsFactory;

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
  /// Throws an [ArgumentError] if the given [deployPathsFactory] is `null`.
  Deployer({
    Services services,
    FileHelper fileHelper,
    Prompter prompter,
    DeployPathsFactory deployPathsFactory,
  })  : _flutterService = services?.flutterService,
        _gcloudService = services?.gcloudService,
        _npmService = services?.npmService,
        _gitService = services?.gitService,
        _firebaseService = services?.firebaseService,
        _sentryService = services?.sentryService,
        _fileHelper = fileHelper,
        _prompter = prompter,
        _deployPathsFactory = deployPathsFactory {
    ArgumentError.checkNotNull(services, 'services');
    ArgumentError.checkNotNull(_flutterService, 'flutterService');
    ArgumentError.checkNotNull(_gcloudService, 'gcloudService');
    ArgumentError.checkNotNull(_npmService, 'npmService');
    ArgumentError.checkNotNull(_gitService, 'gitService');
    ArgumentError.checkNotNull(_firebaseService, 'firebaseService');
    ArgumentError.checkNotNull(_sentryService, 'sentryService');
    ArgumentError.checkNotNull(_fileHelper, 'fileHelper');
    ArgumentError.checkNotNull(_prompter, 'prompter');
    ArgumentError.checkNotNull(_deployPathsFactory, 'deployPathsFactory');
  }

  /// Deploys the Metrics Web Application.
  Future<void> deploy() async {
    await _loginToServices();

    final projectId = await _gcloudService.createProject();

    await _firebaseService.createWebApp(projectId);

    final tempDirectory = _createTempDirectory();
    final deployPaths = _deployPathsFactory.create(tempDirectory.path);

    try {
      await _gitService.checkout(DeployConstants.repoURL, deployPaths.rootPath);
      await _installNpmDependencies(
        deployPaths.firebasePath,
        deployPaths.firebaseFunctionsPath,
      );
      await _flutterService.build(deployPaths.webAppPath);
      await _firebaseService.upgradeBillingPlan(projectId);
      await _firebaseService.enableAnalytics(projectId);
      await _firebaseService.initializeFirestoreData(projectId);

      final googleClientId = await _firebaseService.configureAuthProviders(
        projectId,
      );
      final sentryConfig = await _setupSentry(
        deployPaths.webAppPath,
        deployPaths.webAppBuildPath,
      );

      final metricsConfig = WebMetricsConfig(
        googleSignInClientId: googleClientId,
        sentryConfig: sentryConfig,
      );

      _applyMetricsConfig(metricsConfig, deployPaths.metricsConfigPath);
      await _deployToFirebase(
        projectId,
        deployPaths.firebasePath,
        deployPaths.webAppPath,
      );
      await _gcloudService.configureOauthOrigins(projectId);
    } finally {
      _deleteDirectory(tempDirectory);
    }
  }

  /// Logins to the necessary services.
  Future<void> _loginToServices() async {
    await _gcloudService.login();
    _gcloudService.acceptTermsOfService();

    await _firebaseService.login();
    _firebaseService.acceptTermsOfService();
  }

  /// Installs npm dependencies within the given [firebasePath] and
  /// the [functionsPath].
  Future<void> _installNpmDependencies(
    String firebasePath,
    String functionsPath,
  ) async {
    await _npmService.installDependencies(firebasePath);
    await _npmService.installDependencies(functionsPath);
  }

  /// Sets up a Sentry for the application under deployment within
  /// the given [webPath] and the [buildWebPath].
  Future<SentryConfig> _setupSentry(String webPath, String buildWebPath) async {
    final shouldSetupSentry = _prompter.promptConfirm(
      DeployStrings.setupSentry,
    );

    if (!shouldSetupSentry) return null;

    await _sentryService.login();

    final release = await _createSentryRelease(webPath, buildWebPath);
    final dsn = _sentryService.getProjectDsn(release.project);

    return SentryConfig(
      release: release.name,
      dsn: dsn,
      environment: DeployConstants.sentryEnvironment,
    );
  }

  /// Creates a new Sentry release within the [webPath] and the [buildWebPath].
  Future<SentryRelease> _createSentryRelease(
    String webPath,
    String buildWebPath,
  ) {
    final webSourceMap = SourceMap(
      path: webPath,
      extensions: const ['dart'],
    );

    final buildSourceMap = SourceMap(
      path: buildWebPath,
      extensions: const ['map', 'js'],
    );

    return _sentryService.createRelease([webSourceMap, buildSourceMap]);
  }

  /// Deploys Firebase components and application to the Firebase project
  /// with the given [projectId] within the given [firebasePath] and
  /// the [webPath].
  Future<void> _deployToFirebase(
    String projectId,
    String firebasePath,
    String webPath,
  ) async {
    await _firebaseService.deployFirebase(
      projectId,
      firebasePath,
    );
    await _firebaseService.deployHosting(
      projectId,
      DeployConstants.firebaseTarget,
      webPath,
    );
  }

  /// Applies the given [config] to the Metrics configuration file within
  /// the given [metricsConfigPath].
  void _applyMetricsConfig(WebMetricsConfig config, String metricsConfigPath) {
    final configFile = _fileHelper.getFile(metricsConfigPath);

    _fileHelper.replaceEnvironmentVariables(configFile, config.toMap());
  }

  /// Creates a temporary directory in the current working directory.
  Directory _createTempDirectory() {
    final directory = Directory.current;

    return _fileHelper.createTempDirectory(
      directory,
      DeployConstants.tempDirectoryPrefix,
    );
  }

  /// Deletes the given [directory].
  void _deleteDirectory(Directory directory) {
    final directoryExist = directory.existsSync();

    if (!directoryExist) return;

    directory.deleteSync(recursive: true);
  }
}
