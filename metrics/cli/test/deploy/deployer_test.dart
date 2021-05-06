// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:cli/common/model/services.dart';
import 'package:cli/common/model/web_metrics_config.dart';
import 'package:cli/deploy/constants/deploy_constants.dart';
import 'package:cli/deploy/deployer.dart';
import 'package:cli/deploy/factory/deploy_paths_factory.dart';
import 'package:cli/deploy/model/deploy_paths.dart';
import 'package:cli/deploy/strings/deploy_strings.dart';
import 'package:cli/helper/file_helper.dart';
import 'package:cli/sentry/model/sentry_config.dart';
import 'package:cli/sentry/model/sentry_project.dart';
import 'package:cli/sentry/model/sentry_release.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_utils/directory_mock.dart';
import '../test_utils/firebase_service_mock.dart';
import '../test_utils/flutter_service_mock.dart';
import '../test_utils/gcloud_service_mock.dart';
import '../test_utils/git_service_mock.dart';
import '../test_utils/matchers.dart';
import '../test_utils/npm_service_mock.dart';
import '../test_utils/prompter_mock.dart';
import '../test_utils/sentry_service_mock.dart';
import '../test_utils/services_mock.dart';

// ignore_for_file: avoid_redundant_argument_values, avoid_implementing_value_types, must_be_immutable

void main() {
  group("Deployer", () {
    const projectId = 'testId';
    const clientId = 'clientId';
    const sentryReleaseName = 'sentryReleaseName';
    const sentryDsn = 'sentryDsn';
    const sentryProjectSlug = 'sentryProjectSlug';
    const sentryOrgSlug = 'sentryOrgSlug';
    const tempDirectoryPath = 'tempDirectoryPath';
    const firebaseTarget = DeployConstants.firebaseTarget;
    const repoURL = DeployConstants.repoURL;

    final flutterService = FlutterServiceMock();
    final gcloudService = GCloudServiceMock();
    final npmService = NpmServiceMock();
    final gitService = GitServiceMock();
    final firebaseService = FirebaseServiceMock();
    final sentryService = SentryServiceMock();
    final fileHelper = _FileHelperMock();
    final prompter = PrompterMock();
    final directory = DirectoryMock();
    final servicesMock = ServicesMock();
    final deployPathsFactoryMock = _DeployPathsFactoryMock();
    final deployPathsFactory = DeployPathsFactory();
    final deployPaths = DeployPaths(tempDirectoryPath);
    final sentryProject = SentryProject(
      projectSlug: sentryProjectSlug,
      organizationSlug: sentryOrgSlug,
    );
    final sentryRelease = SentryRelease(
      name: sentryReleaseName,
      project: sentryProject,
    );

    final file = _FileMock();
    final services = Services(
      flutterService: flutterService,
      gcloudService: gcloudService,
      npmService: npmService,
      gitService: gitService,
      firebaseService: firebaseService,
      sentryService: sentryService,
    );
    final deployer = Deployer(
      services: services,
      fileHelper: fileHelper,
      deployPathsFactory: deployPathsFactory,
      prompter: prompter,
    );
    final stateError = StateError('test');

    PostExpectation<Directory> whenCreateTempDirectory() {
      return when(fileHelper.createTempDirectory(any, any));
    }

    PostExpectation<bool> whenDirectoryExist({
      Directory withDirectory,
      String withPath,
    }) {
      final currentDirectory = withDirectory ?? directory;
      whenCreateTempDirectory().thenReturn(currentDirectory);

      final currentPath = withPath ?? tempDirectoryPath;
      when(currentDirectory.path).thenReturn(currentPath);

      return when(currentDirectory.existsSync());
    }

    PostExpectation<Future<String>> whenCreateGCloudProject() {
      return when(gcloudService.createProject());
    }

    PostExpectation<bool> whenPromptToSetupSentry() {
      return when(prompter.promptConfirm(DeployStrings.setupSentry));
    }

    PostExpectation<Future<SentryRelease>> whenCreateSentryRelease() {
      return when(sentryService.createRelease(any));
    }

    tearDown(() {
      reset(flutterService);
      reset(gcloudService);
      reset(npmService);
      reset(gitService);
      reset(firebaseService);
      reset(sentryService);
      reset(fileHelper);
      reset(directory);
      reset(servicesMock);
      reset(prompter);
      reset(file);
      reset(deployPathsFactoryMock);
    });

    test(
      "throws an ArgumentError if the given services is null",
      () {
        expect(
          () => Deployer(
            services: null,
            fileHelper: fileHelper,
            prompter: prompter,
            deployPathsFactory: deployPathsFactory,
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
        when(servicesMock.sentryService).thenReturn(sentryService);

        expect(
          () => Deployer(
            services: servicesMock,
            fileHelper: fileHelper,
            prompter: prompter,
            deployPathsFactory: deployPathsFactory,
          ),
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
        when(servicesMock.sentryService).thenReturn(sentryService);

        expect(
          () => Deployer(
            services: servicesMock,
            fileHelper: fileHelper,
            prompter: prompter,
            deployPathsFactory: deployPathsFactory,
          ),
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
        when(servicesMock.sentryService).thenReturn(sentryService);

        expect(
          () => Deployer(
            services: servicesMock,
            fileHelper: fileHelper,
            prompter: prompter,
            deployPathsFactory: deployPathsFactory,
          ),
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
        when(servicesMock.sentryService).thenReturn(sentryService);

        expect(
          () => Deployer(
            services: servicesMock,
            fileHelper: fileHelper,
            prompter: prompter,
            deployPathsFactory: deployPathsFactory,
          ),
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
        when(servicesMock.sentryService).thenReturn(sentryService);

        expect(
          () => Deployer(
            services: servicesMock,
            fileHelper: fileHelper,
            prompter: prompter,
            deployPathsFactory: deployPathsFactory,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the Sentry service in the given services is null",
      () {
        when(servicesMock.flutterService).thenReturn(flutterService);
        when(servicesMock.gcloudService).thenReturn(gcloudService);
        when(servicesMock.npmService).thenReturn(npmService);
        when(servicesMock.gitService).thenReturn(gitService);
        when(servicesMock.firebaseService).thenReturn(firebaseService);
        when(servicesMock.sentryService).thenReturn(null);

        expect(
          () => Deployer(
            services: servicesMock,
            fileHelper: fileHelper,
            prompter: prompter,
            deployPathsFactory: deployPathsFactory,
          ),
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
            prompter: prompter,
            deployPathsFactory: deployPathsFactory,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given Prompter is null",
      () {
        expect(
          () => Deployer(
            services: services,
            fileHelper: fileHelper,
            prompter: null,
            deployPathsFactory: deployPathsFactory,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given DeployPathsFactory is null",
      () {
        expect(
          () => Deployer(
            services: services,
            fileHelper: fileHelper,
            prompter: prompter,
            deployPathsFactory: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      ".deploy() logs in to the GCloud",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);

        await deployer.deploy();

        verify(gcloudService.login()).called(once);
      },
    );

    test(
      ".deploy() logs in to the GCloud before accepting the terms of the GCloud service",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);

        await deployer.deploy();

        verifyInOrder([
          gcloudService.login(),
          gcloudService.acceptTermsOfService(),
        ]);
      },
    );

    test(
      ".deploy() accepts the terms of the GCloud service",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);

        await deployer.deploy();

        verify(gcloudService.acceptTermsOfService()).called(once);
      },
    );

    test(
      ".deploy() accepts the terms of the GCloud service before creating the GCloud project",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);

        await deployer.deploy();

        verifyInOrder([
          gcloudService.acceptTermsOfService(),
          gcloudService.createProject(),
        ]);
      },
    );

    test(
      ".deploy() logs in to the Firebase",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);

        await deployer.deploy();

        verify(firebaseService.login()).called(once);
      },
    );

    test(
      ".deploy() logs in to the Firebase before accepting the terms of the Firebase service",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);

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
        whenPromptToSetupSentry().thenReturn(false);

        await deployer.deploy();

        verify(firebaseService.acceptTermsOfService()).called(once);
      },
    );

    test(
      ".deploy() accepts the terms of the Firebase service before creating the Firebase web app",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);

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
        whenPromptToSetupSentry().thenReturn(false);

        await deployer.deploy();

        verify(gcloudService.createProject()).called(once);
      },
    );

    test(
      ".deploy() creates the GCloud project before creating the Firebase web app",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);

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
        whenPromptToSetupSentry().thenReturn(false);
        whenCreateGCloudProject().thenAnswer((_) => Future.value(projectId));

        await deployer.deploy();

        verify(firebaseService.createWebApp(projectId)).called(once);
      },
    );

    test(
      ".deploy() creates a temporary directory",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);

        await deployer.deploy();

        verify(fileHelper.createTempDirectory(
          any,
          DeployConstants.tempDirectoryPrefix,
        )).called(once);
      },
    );

    test(
      ".deploy() creates a temporary directory before creating the DeployPaths instance",
      () async {
        final deployer = Deployer(
          fileHelper: fileHelper,
          deployPathsFactory: deployPathsFactoryMock,
          prompter: prompter,
          services: services,
        );

        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);
        when(deployPathsFactoryMock.create(tempDirectoryPath))
            .thenReturn(deployPaths);

        await deployer.deploy();

        verifyInOrder([
          fileHelper.createTempDirectory(any, any),
          deployPathsFactoryMock.create(tempDirectoryPath),
        ]);
      },
    );

    test(
      ".deploy() creates a DeployPaths instance using the given factory",
      () async {
        final deployer = Deployer(
          fileHelper: fileHelper,
          deployPathsFactory: deployPathsFactoryMock,
          prompter: prompter,
          services: services,
        );

        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);
        when(deployPathsFactoryMock.create(tempDirectoryPath))
            .thenReturn(deployPaths);

        await deployer.deploy();

        verify(deployPathsFactoryMock.create(tempDirectoryPath)).called(once);
      },
    );

    test(
      ".deploy() clones the Git repository to the temporary directory",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);

        await deployer.deploy();

        verify(gitService.checkout(repoURL, tempDirectoryPath)).called(once);
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
        whenPromptToSetupSentry().thenReturn(false);

        await deployer.deploy();

        verifyInOrder([
          gitService.checkout(repoURL, tempDirectoryPath),
          flutterService.build(any),
        ]);
      },
    );

    test(
      ".deploy() clones the Git repository before installing the npm dependencies in the Firebase folder",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);

        await deployer.deploy();

        verifyInOrder([
          gitService.checkout(repoURL, tempDirectoryPath),
          npmService.installDependencies(any),
        ]);
      },
    );

    test(
      ".deploy() clones the Git repository before installing the npm dependencies in the Firebase functions folder",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);

        await deployer.deploy();

        verifyInOrder([
          gitService.checkout(repoURL, tempDirectoryPath),
          npmService.installDependencies(any),
        ]);
      },
    );

    test(
      ".deploy() installs the npm dependencies in the Firebase folder",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);

        await deployer.deploy();

        verify(npmService.installDependencies(deployPaths.firebasePath))
            .called(once);
      },
    );

    test(
      ".deploy() installs the npm dependencies in the functions folder",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);

        await deployer.deploy();

        verify(
          npmService.installDependencies(deployPaths.firebaseFunctionsPath),
        ).called(once);
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
        whenPromptToSetupSentry().thenReturn(false);

        await deployer.deploy();

        verifyInOrder([
          npmService.installDependencies(any),
          firebaseService.deployFirebase(any, any),
        ]);
      },
    );

    test(
      ".deploy() installs the npm dependencies in the functions folder before deploying Firebase components",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);

        await deployer.deploy();

        verifyInOrder([
          npmService.installDependencies(any),
          firebaseService.deployFirebase(any, any),
        ]);
      },
    );

    test(
      ".deploy() builds the Flutter application",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);

        await deployer.deploy();

        verify(flutterService.build(deployPaths.webAppPath)).called(once);
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
        whenPromptToSetupSentry().thenReturn(false);

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
        whenPromptToSetupSentry().thenReturn(false);
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
        whenPromptToSetupSentry().thenReturn(false);

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
        whenPromptToSetupSentry().thenReturn(false);
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
        whenPromptToSetupSentry().thenReturn(false);

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
        whenPromptToSetupSentry().thenReturn(false);
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
        whenPromptToSetupSentry().thenReturn(false);

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
        whenPromptToSetupSentry().thenReturn(false);
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
        whenPromptToSetupSentry().thenReturn(false);

        await deployer.deploy();

        verifyInOrder([
          firebaseService.configureAuthProviders(any),
          firebaseService.deployHosting(any, any, any),
        ]);
      },
    );

    test(
      ".deploy() prompts the user whether to configure Sentry",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);

        await deployer.deploy();

        verify(prompter.promptConfirm(DeployStrings.setupSentry)).called(once);
      },
    );

    test(
      ".deploy() deletes the temporary directory if prompter throws during the Sentry config prompting",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenThrow(stateError);

        await expectLater(deployer.deploy(), throwsStateError);

        verify(directory.deleteSync(recursive: true)).called(once);
      },
    );

    test(
      ".deploy() prompts the user to configure the Sentry before logging in to the Sentry",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(true);
        whenCreateSentryRelease()
            .thenAnswer((_) => Future.value(sentryRelease));

        await deployer.deploy();

        verifyInOrder([
          prompter.promptConfirm(DeployStrings.setupSentry),
          sentryService.login(),
        ]);
      },
    );

    test(
      ".deploy() logs in to the Sentry if the user agrees with the Sentry setup",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(true);
        whenCreateSentryRelease()
            .thenAnswer((_) => Future.value(sentryRelease));

        await deployer.deploy();

        verify(sentryService.login()).called(once);
      },
    );

    test(
      ".deploy() does not log in to the Sentry if the user does not agree with the Sentry setup",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);

        await deployer.deploy();

        verifyNever(sentryService.login());
      },
    );

    test(
      ".deploy() deletes the temporary directory if Sentry service throws during the login process",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(true);
        when(sentryService.login()).thenAnswer((_) => Future.error(stateError));

        await expectLater(deployer.deploy(), throwsStateError);

        verify(directory.deleteSync(recursive: true)).called(once);
      },
    );

    test(
      ".deploy() logs in to the Sentry before creating the Sentry release",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(true);
        whenCreateSentryRelease()
            .thenAnswer((_) => Future.value(sentryRelease));

        await deployer.deploy();

        verifyInOrder([
          sentryService.login(),
          sentryService.createRelease(any),
        ]);
      },
    );

    test(
      ".deploy() creates the Sentry release",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(true);
        whenCreateSentryRelease()
            .thenAnswer((_) => Future.value(sentryRelease));

        await deployer.deploy();

        verify(sentryService.createRelease(any)).called(once);
      },
    );

    test(
      ".deploy() deletes the temporary directory if Sentry service throws during the release creation",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(true);
        whenCreateSentryRelease().thenAnswer((_) => Future.error(stateError));

        await expectLater(deployer.deploy(), throwsStateError);

        verify(directory.deleteSync(recursive: true)).called(once);
      },
    );

    test(
      ".deploy() creates the Sentry release before requesting the Sentry project DSN",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(true);
        whenCreateSentryRelease()
            .thenAnswer((_) => Future.value(sentryRelease));

        await deployer.deploy();

        verifyInOrder([
          sentryService.createRelease(any),
          sentryService.getProjectDsn(any),
        ]);
      },
    );

    test(
      ".deploy() requests the Sentry DSN of the created project",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(true);
        whenCreateSentryRelease()
            .thenAnswer((_) => Future.value(sentryRelease));

        await deployer.deploy();

        verify(sentryService.getProjectDsn(sentryRelease.project)).called(once);
      },
    );

    test(
      ".deploy() deletes the temporary directory if prompter throws during the Sentry DSN requesting",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(true);
        whenCreateSentryRelease()
            .thenAnswer((_) => Future.value(sentryRelease));
        when(sentryService.getProjectDsn(any)).thenThrow(stateError);

        await expectLater(deployer.deploy(), throwsStateError);

        verify(directory.deleteSync(recursive: true)).called(once);
      },
    );

    test(
      ".deploy() gets the Metrics config file using the given FileHelper",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);
        whenCreateGCloudProject().thenAnswer((_) => Future.value(projectId));

        await deployer.deploy();

        verify(fileHelper.getFile(deployPaths.metricsConfigPath)).called(once);
      },
    );

    test(
      ".deploy() deletes the temporary directory if FileHelper throws during the Metrics config file getting",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);
        when(fileHelper.getFile(any)).thenThrow(stateError);

        await expectLater(deployer.deploy(), throwsStateError);

        verify(directory.deleteSync(recursive: true)).called(once);
      },
    );

    test(
      ".deploy() replaces the environment variables in the Metrics config file returned by FileHelper with the user-specified values",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(true);
        when(firebaseService.configureAuthProviders(any)).thenReturn(clientId);
        whenCreateSentryRelease()
            .thenAnswer((_) => Future.value(sentryRelease));
        when(sentryService.getProjectDsn(any)).thenReturn(sentryDsn);
        when(fileHelper.getFile(any)).thenReturn(file);

        final sentryConfig = SentryConfig(
          release: sentryRelease.name,
          dsn: sentryDsn,
          environment: DeployConstants.sentryEnvironment,
        );
        final config = WebMetricsConfig(
          googleSignInClientId: clientId,
          sentryConfig: sentryConfig,
        );

        await deployer.deploy();

        verify(fileHelper.replaceEnvironmentVariables(file, config.toMap()))
            .called(once);
      },
    );

    test(
      ".deploy() deletes the temporary directory if FileHelper throws during replacing variables in the Metrics config file",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);
        when(fileHelper.replaceEnvironmentVariables(any, any))
            .thenThrow(stateError);
        when(firebaseService.configureAuthProviders(projectId))
            .thenReturn(clientId);

        await expectLater(deployer.deploy(), throwsStateError);

        verify(directory.deleteSync(recursive: true)).called(once);
      },
    );

    test(
      ".deploy() updates the Metrics config file before deploying to the hosting",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);

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
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);

        await deployer.deploy();

        verify(firebaseService.deployFirebase(
          projectId,
          deployPaths.firebasePath,
        )).called(once);
      },
    );

    test(
      ".deploy() deletes the temporary directory if Firebase service throws during the Firebase components deployment",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);
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
        whenPromptToSetupSentry().thenReturn(false);

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
        whenPromptToSetupSentry().thenReturn(false);
        whenCreateGCloudProject().thenAnswer((_) => Future.value(projectId));

        await deployer.deploy();

        verify(firebaseService.deployHosting(
          projectId,
          firebaseTarget,
          deployPaths.webAppPath,
        )).called(once);
      },
    );

    test(
      ".deploy() deletes the temporary directory if Firebase service throws during the Firebase hosting deployment",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);
        when(firebaseService.deployHosting(any, any, any))
            .thenAnswer((_) => Future.error(stateError));

        await expectLater(deployer.deploy(), throwsStateError);

        verify(directory.deleteSync(recursive: true)).called(once);
      },
    );

    test(
      ".deploy() deploys a target to the hosting before configuring GCloud OAuth origins",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);

        await deployer.deploy();

        verifyInOrder([
          firebaseService.deployHosting(any, any, any),
          gcloudService.configureOAuthOrigins(any),
        ]);
      },
    );

    test(
      ".deploy() configures GCloud OAuth Authorized JavaScript origins",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);
        whenCreateGCloudProject().thenAnswer((_) => Future.value(projectId));

        await deployer.deploy();

        verify(gcloudService.configureOAuthOrigins(projectId)).called(once);
      },
    );

    test(
      ".deploy() deletes the temporary directory if GCloud service throws during the OAuth origins configuration",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);
        when(gcloudService.configureOAuthOrigins(any)).thenThrow(stateError);

        await expectLater(deployer.deploy(), throwsStateError);

        verify(directory.deleteSync(recursive: true)).called(once);
      },
    );

    test(
      ".deploy() configures GCloud OAuth origins before deleting the temporary directory",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);
        whenCreateGCloudProject().thenAnswer((_) => Future.value(projectId));

        await deployer.deploy();

        verifyInOrder([
          gcloudService.configureOAuthOrigins(any),
          directory.deleteSync(recursive: true),
        ]);
      },
    );

    test(
      ".deploy() deletes the temporary directory if it exists",
      () async {
        whenDirectoryExist().thenReturn(true);
        whenPromptToSetupSentry().thenReturn(false);

        await deployer.deploy();

        verify(directory.deleteSync(recursive: true)).called(once);
      },
    );

    test(
      ".deploy() does not delete the temporary directory if it does not exist",
      () async {
        whenDirectoryExist().thenReturn(false);
        whenPromptToSetupSentry().thenReturn(false);

        await deployer.deploy();

        verifyNever(directory.delete(recursive: true));
      },
    );
  });
}

class _FileHelperMock extends Mock implements FileHelper {}

class _FileMock extends Mock implements File {}

class _DeployPathsFactoryMock extends Mock implements DeployPathsFactory {}
