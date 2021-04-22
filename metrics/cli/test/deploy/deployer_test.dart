// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:cli/common/model/metrics_config.dart';
import 'package:cli/common/model/services.dart';
import 'package:cli/deploy/constants/deploy_constants.dart';
import 'package:cli/deploy/deployer.dart';
import 'package:cli/helper/file_helper.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_utils/directory_mock.dart';
import '../test_utils/firebase_service_mock.dart';
import '../test_utils/flutter_service_mock.dart';
import '../test_utils/gcloud_service_mock.dart';
import '../test_utils/git_service_mock.dart';
import '../test_utils/matchers.dart';
import '../test_utils/npm_service_mock.dart';
import '../test_utils/services_mock.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("Deployer", () {
    const projectId = 'testId';
    const clientId = 'clientId';
    const firebasePath = DeployConstants.firebasePath;
    const firebaseFunctionsPath = DeployConstants.firebaseFunctionsPath;
    const firebaseTarget = DeployConstants.firebaseTarget;
    const webPath = DeployConstants.webPath;
    const configPath = DeployConstants.metricsConfigPath;
    const repoURL = DeployConstants.repoURL;
    const tempDir = DeployConstants.tempDir;

    final flutterService = FlutterServiceMock();
    final gcloudService = GCloudServiceMock();
    final npmService = NpmServiceMock();
    final gitService = GitServiceMock();
    final firebaseService = FirebaseServiceMock();
    final fileHelper = _FileHelperMock();
    final directory = DirectoryMock();
    final servicesMock = ServicesMock();
    final file = _FileMock();
    final services = Services(
      flutterService: flutterService,
      gcloudService: gcloudService,
      npmService: npmService,
      gitService: gitService,
      firebaseService: firebaseService,
    );
    final deployer = Deployer(
      services: services,
      fileHelper: fileHelper,
    );
    final stateError = StateError('test');

    PostExpectation<Directory> whenGetDirectory() {
      return when(fileHelper.getDirectory(any));
    }

    PostExpectation<bool> whenDirectoryExist({Directory withDirectory}) {
      final currentDirectory = withDirectory ?? directory;
      whenGetDirectory().thenReturn(currentDirectory);
      return when(currentDirectory.existsSync());
    }

    PostExpectation<Future<String>> whenCreateGCloudProject() {
      return when(gcloudService.createProject());
    }

    tearDown(() {
      reset(flutterService);
      reset(gcloudService);
      reset(npmService);
      reset(gitService);
      reset(firebaseService);
      reset(fileHelper);
      reset(directory);
      reset(servicesMock);
      reset(file);
    });

    test(
      "throws an ArgumentError if the given services is null",
      () {
        expect(
          () => Deployer(
            services: null,
            fileHelper: fileHelper,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the Flutter service in the given services is null",
      () {
        when(servicesMock.flutterService).thenReturn(null);
        when(servicesMock.gcloudService).thenReturn(gcloudService);
        when(servicesMock.npmService).thenReturn(npmService);
        when(servicesMock.gitService).thenReturn(gitService);
        when(servicesMock.firebaseService).thenReturn(firebaseService);

        expect(
          () => Deployer(services: servicesMock, fileHelper: fileHelper),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the GCloud service in the given services is null",
      () {
        when(servicesMock.flutterService).thenReturn(flutterService);
        when(servicesMock.gcloudService).thenReturn(null);
        when(servicesMock.npmService).thenReturn(npmService);
        when(servicesMock.gitService).thenReturn(gitService);
        when(servicesMock.firebaseService).thenReturn(firebaseService);

        expect(
          () => Deployer(services: servicesMock, fileHelper: fileHelper),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the Npm service in the given services is null",
      () {
        when(servicesMock.flutterService).thenReturn(flutterService);
        when(servicesMock.gcloudService).thenReturn(gcloudService);
        when(servicesMock.npmService).thenReturn(null);
        when(servicesMock.gitService).thenReturn(gitService);
        when(servicesMock.firebaseService).thenReturn(firebaseService);

        expect(
          () => Deployer(services: servicesMock, fileHelper: fileHelper),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the Git service in the given services is null",
      () {
        when(servicesMock.flutterService).thenReturn(flutterService);
        when(servicesMock.gcloudService).thenReturn(gcloudService);
        when(servicesMock.npmService).thenReturn(npmService);
        when(servicesMock.gitService).thenReturn(null);
        when(servicesMock.firebaseService).thenReturn(firebaseService);

        expect(
          () => Deployer(services: servicesMock, fileHelper: fileHelper),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the Firebase service in the given services is null",
      () {
        when(servicesMock.flutterService).thenReturn(flutterService);
        when(servicesMock.gcloudService).thenReturn(gcloudService);
        when(servicesMock.npmService).thenReturn(npmService);
        when(servicesMock.gitService).thenReturn(gitService);
        when(servicesMock.firebaseService).thenReturn(null);

        expect(
          () => Deployer(services: servicesMock, fileHelper: fileHelper),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given FileHelper is null",
      () {
        expect(
          () => Deployer(
            services: services,
            fileHelper: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      ".deploy() logs in to the GCloud",
      () async {
        whenDirectoryExist().thenReturn(true);

        await deployer.deploy();

        verify(gcloudService.login()).called(once);
      },
    );

    test(
      ".deploy() logs in to the GCloud before creating the GCloud project",
      () async {
        whenDirectoryExist().thenReturn(true);

        await deployer.deploy();

        verifyInOrder([
          gcloudService.login(),
          gcloudService.createProject(),
        ]);
      },
    );

    test(
      ".deploy() logs in to the Firebase",
      () async {
        whenDirectoryExist().thenReturn(true);

        await deployer.deploy();

        verify(firebaseService.login()).called(once);
      },
    );

    test(
      ".deploy() logs in to the Firebase before accepting the terms of the Firebase service",
      () async {
        whenDirectoryExist().thenReturn(true);

        await deployer.deploy();

        verifyInOrder([
          firebaseService.login(),
          firebaseService.acceptTermsOfService(),
        ]);
      },
    );

    test(
      ".deploy() accepts the terms of the Firebase service",
      () async {
        whenDirectoryExist().thenReturn(true);

        await deployer.deploy();

        verify(firebaseService.acceptTermsOfService()).called(once);
      },
    );

    test(
      ".deploy() accepts the terms of the Firebase service before creating the Firebase web app",
      () async {
        whenDirectoryExist().thenReturn(true);

        await deployer.deploy();

        verifyInOrder([
          firebaseService.acceptTermsOfService(),
          firebaseService.createWebApp(any),
        ]);
      },
    );

    test(
      ".deploy() creates the GCloud project",
      () async {
        whenDirectoryExist().thenReturn(true);

        await deployer.deploy();

        verify(gcloudService.createProject()).called(once);
      },
    );

    test(
      ".deploy() creates the GCloud project before creating the Firebase web app",
      () async {
        whenDirectoryExist().thenReturn(true);

        await deployer.deploy();

        verifyInOrder([
          gcloudService.createProject(),
          firebaseService.createWebApp(any),
        ]);
      },
    );

    test(
      ".deploy() creates the Firebase web app for the created GCloud project",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenCreateGCloudProject().thenAnswer((_) => Future.value(projectId));

        await deployer.deploy();

        verify(firebaseService.createWebApp(projectId)).called(once);
      },
    );

    test(
      ".deploy() clones the Git repository",
      () async {
        whenDirectoryExist().thenReturn(true);

        await deployer.deploy();

        verify(gitService.checkout(repoURL, tempDir)).called(once);
      },
    );

    test(
      ".deploy() deletes the temporary directory if Git service throws during the checkout process",
      () async {
        whenDirectoryExist().thenReturn(true);
        when(gitService.checkout(any, any))
            .thenAnswer((_) => Future.error(stateError));

        await expectLater(deployer.deploy(), throwsStateError);

        verify(directory.deleteSync(recursive: true)).called(once);
      },
    );

    test(
      ".deploy() clones the Git repository before building the Flutter application",
      () async {
        whenDirectoryExist().thenReturn(true);

        await deployer.deploy();

        verifyInOrder([
          gitService.checkout(repoURL, tempDir),
          flutterService.build(webPath),
        ]);
      },
    );

    test(
      ".deploy() clones the Git repository before installing the npm dependencies in the Firebase folder",
      () async {
        whenDirectoryExist().thenReturn(true);

        await deployer.deploy();

        verifyInOrder([
          gitService.checkout(repoURL, tempDir),
          npmService.installDependencies(DeployConstants.firebasePath),
        ]);
      },
    );

    test(
      ".deploy() clones the Git repository before installing the npm dependencies in the Firebase functions folder",
      () async {
        whenDirectoryExist().thenReturn(true);

        await deployer.deploy();

        verifyInOrder([
          gitService.checkout(repoURL, tempDir),
          npmService.installDependencies(DeployConstants.firebaseFunctionsPath),
        ]);
      },
    );

    test(
      ".deploy() installs the npm dependencies in the Firebase folder",
      () async {
        whenDirectoryExist().thenReturn(true);

        await deployer.deploy();

        verify(npmService.installDependencies(firebasePath)).called(once);
      },
    );

    test(
      ".deploy() installs the npm dependencies in the functions folder",
      () async {
        whenDirectoryExist().thenReturn(true);

        await deployer.deploy();

        verify(npmService.installDependencies(firebaseFunctionsPath))
            .called(once);
      },
    );

    test(
      ".deploy() deletes the temporary directory if Npm service throws during the dependencies installing",
      () async {
        whenDirectoryExist().thenReturn(true);
        when(npmService.installDependencies(any))
            .thenAnswer((_) => Future.error(stateError));

        await expectLater(deployer.deploy(), throwsStateError);

        verify(directory.deleteSync(recursive: true)).called(once);
      },
    );

    test(
      ".deploy() installs the npm dependencies in the Firebase folder before deploying Firebase components",
      () async {
        whenDirectoryExist().thenReturn(true);

        await deployer.deploy();

        verifyInOrder([
          npmService.installDependencies(firebasePath),
          firebaseService.deployFirebase(any, any),
        ]);
      },
    );

    test(
      ".deploy() installs the npm dependencies in the functions folder before deploying Firebase components",
      () async {
        whenDirectoryExist().thenReturn(true);

        await deployer.deploy();

        verifyInOrder([
          npmService.installDependencies(firebaseFunctionsPath),
          firebaseService.deployFirebase(any, any),
        ]);
      },
    );

    test(
      ".deploy() builds the Flutter application",
      () async {
        whenDirectoryExist().thenReturn(true);

        await deployer.deploy();

        verify(flutterService.build(webPath)).called(once);
      },
    );

    test(
      ".deploy() deletes the temporary directory if Flutter service throws during the web application building",
      () async {
        whenDirectoryExist().thenReturn(true);
        when(flutterService.build(any))
            .thenAnswer((_) => Future.error(stateError));

        await expectLater(deployer.deploy(), throwsStateError);

        verify(directory.deleteSync(recursive: true)).called(once);
      },
    );

    test(
      ".deploy() builds the Flutter application before deploying to the hosting",
      () async {
        whenDirectoryExist().thenReturn(true);

        await deployer.deploy();

        verifyInOrder([
          flutterService.build(any),
          firebaseService.deployHosting(any, any, any),
        ]);
      },
    );

    test(
      ".deploy() upgrades the Firebase billing plan",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenCreateGCloudProject().thenAnswer((_) => Future.value(projectId));

        await deployer.deploy();

        verify(firebaseService.upgradeBillingPlan(projectId)).called(once);
      },
    );

    test(
      ".deploy() deletes the temporary directory if Firebase service throws during the Firebase billing plan upgrading",
      () async {
        whenDirectoryExist().thenReturn(true);
        when(firebaseService.upgradeBillingPlan(any)).thenThrow(stateError);

        await expectLater(deployer.deploy(), throwsStateError);

        verify(directory.deleteSync(recursive: true)).called(once);
      },
    );

    test(
      ".deploy() upgrades the Firebase billing plan before deploying the Firebase components",
      () async {
        whenDirectoryExist().thenReturn(true);

        await deployer.deploy();

        verifyInOrder([
          firebaseService.upgradeBillingPlan(any),
          firebaseService.deployFirebase(any, any),
        ]);
      },
    );

    test(
      ".deploy() enables the Firebase Analytics",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenCreateGCloudProject().thenAnswer((_) => Future.value(projectId));

        await deployer.deploy();

        verify(firebaseService.enableAnalytics(projectId)).called(once);
      },
    );

    test(
      ".deploy() deletes the temporary directory if the Firebase service throws during the Firebase Analytics enabling",
      () async {
        whenDirectoryExist().thenReturn(true);
        when(firebaseService.enableAnalytics(any)).thenThrow(stateError);

        await expectLater(deployer.deploy(), throwsStateError);

        verify(directory.deleteSync(recursive: true)).called(once);
      },
    );

    test(
      ".deploy() enables the Firebase Analytics before deploying to the hosting",
      () async {
        whenDirectoryExist().thenReturn(true);

        await deployer.deploy();

        verifyInOrder([
          firebaseService.enableAnalytics(any),
          firebaseService.deployHosting(any, any, any),
        ]);
      },
    );

    test(
      ".deploy() initializes the Firestore data",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenCreateGCloudProject().thenAnswer((_) => Future.value(projectId));

        await deployer.deploy();

        verify(firebaseService.initializeFirestoreData(projectId)).called(once);
      },
    );

    test(
      ".deploy() deletes the temporary directory if the Firebase service throws during the Firebase Analytics enabling",
      () async {
        whenDirectoryExist().thenReturn(true);
        when(firebaseService.initializeFirestoreData(any))
            .thenThrow(stateError);

        await expectLater(deployer.deploy(), throwsStateError);

        verify(directory.deleteSync(recursive: true)).called(once);
      },
    );

    test(
      ".deploy() initializes the Firestore data before deploying to the hosting",
      () async {
        whenDirectoryExist().thenReturn(true);

        await deployer.deploy();

        verifyInOrder([
          firebaseService.initializeFirestoreData(any),
          firebaseService.deployHosting(any, any, any),
        ]);
      },
    );

    test(
      ".deploy() configures the Firebase auth providers",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenCreateGCloudProject().thenAnswer((_) => Future.value(projectId));

        await deployer.deploy();

        verify(firebaseService.configureAuthProviders(projectId)).called(once);
      },
    );

    test(
      ".deploy() deletes the temporary directory if the Firebase service throws during the Firebase auth providers configuration",
      () async {
        whenDirectoryExist().thenReturn(true);
        when(firebaseService.configureAuthProviders(any)).thenThrow(stateError);

        await expectLater(deployer.deploy(), throwsStateError);

        verify(directory.deleteSync(recursive: true)).called(once);
      },
    );

    test(
      ".deploy() configures the Firebase auth providers before deploying to the hosting",
      () async {
        whenDirectoryExist().thenReturn(true);

        await deployer.deploy();

        verifyInOrder([
          firebaseService.configureAuthProviders(any),
          firebaseService.deployHosting(any, any, any),
        ]);
      },
    );

    test(
      ".deploy() gets the Metrics config file using the given FileHelper",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenCreateGCloudProject().thenAnswer((_) => Future.value(projectId));

        await deployer.deploy();

        verify(fileHelper.getFile(configPath)).called(once);
      },
    );

    test(
      ".deploy() deletes the temporary directory if FileHelper throws during the Metrics config file getting",
      () async {
        whenDirectoryExist().thenReturn(true);
        when(fileHelper.getFile(any)).thenThrow(stateError);

        await expectLater(deployer.deploy(), throwsStateError);

        verify(directory.deleteSync(recursive: true)).called(once);
      },
    );

    test(
      ".deploy() replaces the environment variables in the Metrics config file returned by FileHelper with the user-specified values",
      () async {
        whenDirectoryExist().thenReturn(true);
        when(firebaseService.configureAuthProviders(any)).thenReturn(clientId);
        when(fileHelper.getFile(configPath)).thenReturn(file);

        final config = MetricsConfig(googleSignInClientId: clientId);

        await deployer.deploy();

        verify(fileHelper.replaceEnvironmentVariables(file, config.toMap()))
            .called(once);
      },
    );

    test(
      ".deploy() deletes the temporary directory if FileHelper throws during replacing variables in the Metrics config file",
      () async {
        whenGetDirectory().thenReturn(directory);
        whenDirectoryExist().thenReturn(true);
        when(fileHelper.replaceEnvironmentVariables(any, any))
            .thenThrow(stateError);
        when(firebaseService.configureAuthProviders(projectId))
            .thenReturn(clientId);
        when(fileHelper.getFile(configPath)).thenReturn(file);

        await expectLater(deployer.deploy(), throwsStateError);

        verify(directory.deleteSync(recursive: true)).called(once);
      },
    );

    test(
      ".deploy() updates the Metrics config file before deploying to the hosting",
      () async {
        whenGetDirectory().thenReturn(directory);
        whenDirectoryExist().thenReturn(true);

        await deployer.deploy();

        verifyInOrder([
          fileHelper.replaceEnvironmentVariables(any, any),
          firebaseService.deployHosting(any, any, any),
        ]);
      },
    );

    test(
      ".deploy() deploys Firebase components to the Firebase",
      () async {
        whenCreateGCloudProject().thenAnswer((_) => Future.value(projectId));
        whenGetDirectory().thenReturn(directory);
        whenDirectoryExist().thenReturn(true);

        await deployer.deploy();

        verify(firebaseService.deployFirebase(projectId, firebasePath))
            .called(once);
      },
    );

    test(
      ".deploy() deletes the temporary directory if Firebase service throws during the Firebase components deployment",
      () async {
        whenDirectoryExist().thenReturn(true);
        when(firebaseService.deployFirebase(any, any))
            .thenAnswer((_) => Future.error(stateError));

        await expectLater(deployer.deploy(), throwsStateError);

        verify(directory.deleteSync(recursive: true)).called(once);
      },
    );

    test(
      ".deploy() deploys Firebase components before deploying to the hosting",
      () async {
        whenDirectoryExist().thenReturn(true);

        await deployer.deploy();

        verifyInOrder([
          firebaseService.deployFirebase(any, any),
          firebaseService.deployHosting(any, any, any),
        ]);
      },
    );

    test(
      ".deploy() deploys the target to the hosting",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenCreateGCloudProject().thenAnswer((_) => Future.value(projectId));

        await deployer.deploy();

        verify(firebaseService.deployHosting(
          projectId,
          firebaseTarget,
          webPath,
        )).called(once);
      },
    );

    test(
      ".deploy() deletes the temporary directory if Firebase service throws during the Firebase hosting deployment",
      () async {
        whenDirectoryExist().thenReturn(true);
        when(firebaseService.deployHosting(any, any, any))
            .thenAnswer((_) => Future.error(stateError));

        await expectLater(deployer.deploy(), throwsStateError);

        verify(directory.deleteSync(recursive: true)).called(once);
      },
    );

    test(
      ".deploy() deploys a target to the hosting before deleting the temporary directory",
      () async {
        whenDirectoryExist().thenReturn(true);

        await deployer.deploy();

        verifyInOrder([
          firebaseService.deployHosting(any, any, any),
          directory.deleteSync(recursive: true),
        ]);
      },
    );

    test(
      ".deploy() deletes the temporary directory if it exists",
      () async {
        whenDirectoryExist().thenReturn(true);

        await deployer.deploy();

        verify(directory.deleteSync(recursive: true)).called(once);
      },
    );

    test(
      ".deploy() does not delete the temporary directory if it does not exist",
      () async {
        whenDirectoryExist().thenReturn(false);

        await deployer.deploy();

        verifyNever(directory.delete(recursive: true));
      },
    );
  });
}

class _FileHelperMock extends Mock implements FileHelper {}

class _FileMock extends Mock implements File {}
