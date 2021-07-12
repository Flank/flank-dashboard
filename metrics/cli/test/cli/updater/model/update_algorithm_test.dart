import 'package:cli/cli/deployer/constants/deploy_constants.dart';
import 'package:cli/cli/updater/model/update_algorithm.dart';
import 'package:cli/common/model/config/firebase_config.dart';
import 'package:cli/common/model/config/sentry_config.dart';
import 'package:cli/common/model/config/sentry_web_config.dart';
import 'package:cli/common/model/config/update_config.dart';
import 'package:cli/common/model/config/web_metrics_config.dart';
import 'package:cli/common/model/paths/paths.dart';
import 'package:cli/common/model/services/services.dart';
import 'package:cli/services/sentry/model/sentry_project.dart';
import 'package:cli/services/sentry/model/sentry_release.dart';
import 'package:cli/services/sentry/model/source_map.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../test_utils/file_helper_mock.dart';
import '../../../test_utils/file_mock.dart';
import '../../../test_utils/firebase_service_mock.dart';
import '../../../test_utils/flutter_service_mock.dart';
import '../../../test_utils/gcloud_service_mock.dart';
import '../../../test_utils/git_service_mock.dart';
import '../../../test_utils/matchers.dart';
import '../../../test_utils/npm_service_mock.dart';
import '../../../test_utils/sentry_service_mock.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("UpdateAlgorithm", () {
    const root = 'root';
    const repoURL = DeployConstants.repoURL;
    const target = DeployConstants.firebaseTarget;

    final paths = Paths(root);
    final rootPath = paths.rootPath;
    final firebasePath = paths.firebasePath;
    final functionsPath = paths.firebaseFunctionsPath;
    final webAppPath = paths.webAppPath;
    final metricsConfigPath = paths.metricsConfigPath;
    final webSourceMap = SourceMap(
      path: webAppPath,
      extensions: const ['dart'],
    );
    final buildSourceMap = SourceMap(
      path: paths.webAppBuildPath,
      extensions: const ['map', 'js'],
    );
    final sourceMaps = [webSourceMap, buildSourceMap];
    final firebaseConfig = FirebaseConfig(
      authToken: 'firebaseToken',
      projectId: 'projectId',
      googleSignInClientId: 'googleSignInClientId',
    );
    final sentryConfig = SentryConfig(
      authToken: 'sentryToken',
      organizationSlug: 'organizationSlug',
      projectSlug: 'projectSlug',
      projectDsn: 'projectDsn',
      releaseName: 'releaseName',
    );
    final updateConfig = UpdateConfig(
      firebaseConfig: firebaseConfig,
      sentryConfig: sentryConfig,
    );
    final sentryProject = SentryProject(
      projectSlug: sentryConfig.projectSlug,
      organizationSlug: sentryConfig.organizationSlug,
    );
    final sentryRelease = SentryRelease(
      name: sentryConfig.releaseName,
      project: sentryProject,
    );
    final sentryWebConfig = SentryWebConfig(
      release: sentryConfig.releaseName,
      dsn: sentryConfig.projectDsn,
      environment: DeployConstants.sentryEnvironment,
    );
    final config = WebMetricsConfig(
      googleSignInClientId: firebaseConfig.googleSignInClientId,
      sentryWebConfig: sentryWebConfig,
    );
    final environmentMap = config.toMap();
    final projectId = firebaseConfig.projectId;
    final firebaseAuthToken = firebaseConfig.authToken;
    final sentryAuthToken = sentryConfig.authToken;

    final fileHelper = FileHelperMock();
    final flutterService = FlutterServiceMock();
    final gcloudService = GCloudServiceMock();
    final npmService = NpmServiceMock();
    final gitService = GitServiceMock();
    final firebaseService = FirebaseServiceMock();
    final sentryService = SentryServiceMock();
    final file = FileMock();
    final services = Services(
      flutterService: flutterService,
      gcloudService: gcloudService,
      npmService: npmService,
      gitService: gitService,
      firebaseService: firebaseService,
      sentryService: sentryService,
    );
    final updateAlgorithm = UpdateAlgorithm(
      services: services,
      fileHelper: fileHelper,
    );

    tearDown(() {
      reset(fileHelper);
      reset(flutterService);
      reset(gcloudService);
      reset(npmService);
      reset(gitService);
      reset(firebaseService);
      reset(sentryService);
      reset(file);
    });

    test(
      "throws an ArgumentError if the given Services is null",
      () {
        expect(
          () => UpdateAlgorithm(
            services: null,
            fileHelper: fileHelper,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given FileHelper is null",
      () {
        expect(
          () => UpdateAlgorithm(
            services: services,
            fileHelper: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      ".start() throws an ArgumentError if the given config is null",
      () {
        expect(
          () => updateAlgorithm.start(null, paths),
          throwsArgumentError,
        );
      },
    );

    test(
      ".start() throws an ArgumentError if the given paths is null",
      () {
        expect(
          () => updateAlgorithm.start(updateConfig, null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".start() clones the Git repository to the root path",
      () async {
        await updateAlgorithm.start(updateConfig, paths);

        verify(gitService.checkout(repoURL, rootPath)).called(once);
      },
    );

    test(
      ".start() clones the Git repository before installing the Npm dependencies in the Firebase folder",
      () async {
        await updateAlgorithm.start(updateConfig, paths);

        verifyInOrder([
          gitService.checkout(repoURL, rootPath),
          npmService.installDependencies(firebasePath),
        ]);
      },
    );

    test(
      ".start() clones the Git repository before installing the Npm dependencies in the functions folder",
      () async {
        await updateAlgorithm.start(updateConfig, paths);

        verifyInOrder([
          gitService.checkout(repoURL, rootPath),
          npmService.installDependencies(functionsPath),
        ]);
      },
    );

    test(
      ".start() installs the npm dependencies in the Firebase folder",
      () async {
        await updateAlgorithm.start(updateConfig, paths);

        verify(npmService.installDependencies(firebasePath)).called(once);
      },
    );

    test(
      ".start() installs the npm dependencies in the functions folder",
      () async {
        await updateAlgorithm.start(updateConfig, paths);

        verify(npmService.installDependencies(functionsPath)).called(once);
      },
    );

    test(
      ".start() installs the npm dependencies in the Firebase folder before deploying Firebase components",
      () async {
        await updateAlgorithm.start(updateConfig, paths);

        verifyInOrder([
          npmService.installDependencies(firebasePath),
          firebaseService.deployFirebase(
            projectId,
            firebasePath,
          ),
        ]);
      },
    );

    test(
      ".start() installs the npm dependencies in the functions folder before deploying Firebase components",
      () async {
        await updateAlgorithm.start(updateConfig, paths);

        verifyInOrder([
          npmService.installDependencies(functionsPath),
          firebaseService.deployFirebase(
            projectId,
            firebasePath,
          ),
        ]);
      },
    );

    test(
      ".start() builds the Flutter application",
      () async {
        await updateAlgorithm.start(updateConfig, paths);

        verify(flutterService.build(webAppPath)).called(once);
      },
    );

    test(
      ".start() builds the Flutter application before creating Sentry release",
      () async {
        await updateAlgorithm.start(updateConfig, paths);

        verifyInOrder([
          flutterService.build(webAppPath),
          sentryService.createRelease(sentryRelease, sourceMaps),
        ]);
      },
    );

    test(
      ".start() builds the Flutter application before deploying to the hosting",
      () async {
        await updateAlgorithm.start(updateConfig, paths);

        verifyInOrder([
          flutterService.build(webAppPath),
          firebaseService.deployHosting(
            projectId,
            DeployConstants.firebaseTarget,
            webAppPath,
          ),
        ]);
      },
    );

    test(
      ".start() initializes auth token for the Firebase",
      () async {
        await updateAlgorithm.start(updateConfig, paths);

        verify(firebaseService.initializeAuth(firebaseAuthToken)).called(once);
      },
    );

    test(
      ".start() initializes auth token for the Firebase before deploying Firebase components",
      () async {
        await updateAlgorithm.start(updateConfig, paths);

        verifyInOrder([
          firebaseService.initializeAuth(firebaseAuthToken),
          firebaseService.deployFirebase(
            projectId,
            firebasePath,
          ),
        ]);
      },
    );

    test(
      ".start() initializes auth token for the Firebase before deploying to the hosting",
      () async {
        await updateAlgorithm.start(updateConfig, paths);

        verifyInOrder([
          firebaseService.initializeAuth(firebaseAuthToken),
          firebaseService.deployHosting(
            projectId,
            DeployConstants.firebaseTarget,
            webAppPath,
          ),
        ]);
      },
    );

    test(
      ".start() does not create the Sentry release if the sentry config is null",
      () async {
        final config = UpdateConfig(
          firebaseConfig: firebaseConfig,
          sentryConfig: null,
        );

        await updateAlgorithm.start(config, paths);

        verifyNever(sentryService.createRelease(any, any));
      },
    );

    test(
      ".start() initializes auth token for the Sentry",
      () async {
        await updateAlgorithm.start(updateConfig, paths);

        verify(sentryService.initializeAuth(sentryAuthToken)).called(once);
      },
    );

    test(
      ".start() initializes auth token for the Sentry before creating Sentry release",
      () async {
        await updateAlgorithm.start(updateConfig, paths);

        verifyInOrder([
          sentryService.initializeAuth(sentryAuthToken),
          sentryService.createRelease(sentryRelease, sourceMaps),
        ]);
      },
    );

    test(
      ".start() creates the Sentry release",
      () async {
        await updateAlgorithm.start(updateConfig, paths);

        verify(sentryService.createRelease(
          sentryRelease,
          sourceMaps,
        )).called(once);
      },
    );

    test(
      ".start() gets the Metrics config file using the given FileHelper",
      () async {
        await updateAlgorithm.start(updateConfig, paths);

        verify(fileHelper.getFile(metricsConfigPath)).called(once);
      },
    );

    test(
      ".start() replaces the environment variables in the Metrics config file without sentry web configuration if the sentry config is null",
      () async {
        final config = UpdateConfig(
          firebaseConfig: firebaseConfig,
          sentryConfig: null,
        );
        final metricsConfig = WebMetricsConfig(
          googleSignInClientId: firebaseConfig.googleSignInClientId,
          sentryWebConfig: null,
        );
        final expectedEnvironmentMap = metricsConfig.toMap();

        when(fileHelper.getFile(metricsConfigPath)).thenReturn(file);

        await updateAlgorithm.start(config, paths);

        verify(fileHelper.replaceEnvironmentVariables(
          file,
          expectedEnvironmentMap,
        )).called(once);
      },
    );

    test(
      ".start() replaces the environment variables in the Metrics config file",
      () async {
        when(fileHelper.getFile(metricsConfigPath)).thenReturn(file);

        await updateAlgorithm.start(updateConfig, paths);

        verify(fileHelper.replaceEnvironmentVariables(
          file,
          environmentMap,
        )).called(once);
      },
    );

    test(
      ".start() updates the Metrics config file before deploying to the hosting",
      () async {
        when(fileHelper.getFile(metricsConfigPath)).thenReturn(file);

        await updateAlgorithm.start(updateConfig, paths);

        verifyInOrder([
          fileHelper.replaceEnvironmentVariables(file, environmentMap),
          firebaseService.deployHosting(
            projectId,
            target,
            webAppPath,
          ),
        ]);
      },
    );

    test(
      ".start() deploys Firebase components to the Firebase",
      () async {
        await updateAlgorithm.start(updateConfig, paths);

        verify(firebaseService.deployFirebase(
          projectId,
          firebasePath,
        )).called(once);
      },
    );

    test(
      ".start() deploys Firebase components before deploying to the hosting",
      () async {
        await updateAlgorithm.start(updateConfig, paths);

        verifyInOrder([
          firebaseService.deployFirebase(
            projectId,
            firebasePath,
          ),
          firebaseService.deployHosting(
            projectId,
            target,
            webAppPath,
          ),
        ]);
      },
    );

    test(
      ".start() deploys the target to the hosting",
      () async {
        await updateAlgorithm.start(updateConfig, paths);

        verify(firebaseService.deployHosting(
          projectId,
          target,
          webAppPath,
        )).called(once);
      },
    );
  });
}
