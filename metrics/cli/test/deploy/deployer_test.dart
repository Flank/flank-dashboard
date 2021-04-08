// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:cli/common/model/services.dart';
import 'package:cli/deploy/constants/deploy_constants.dart';
import 'package:cli/deploy/deployer.dart';
import 'package:cli/helper/file_helper.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_utils/directory_mock.dart';
import '../test_utils/firebase_command_mock.dart';
import '../test_utils/flutter_service_mock.dart';
import '../test_utils/gcloud_service_mock.dart';
import '../test_utils/git_command_mock.dart';
import '../test_utils/matchers.dart';
import '../test_utils/npm_service_mock.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("Deployer", () {
    const projectId = 'testId';
    const firebaseToken = 'testToken';
    final gcloudService = GCloudServiceMock();
    final flutterService = FlutterServiceMock();
    final npmService = NpmServiceMock();
    final firebaseCommand = FirebaseCommandMock();
    final gitCommand = GitCommandMock();
    final fileHelper = _FileHelperMock();
    final directory = DirectoryMock();
    final services = Services(
      flutterService: flutterService,
      gcloudService: gcloudService,
      npmService: npmService,
    );
    final deployer = Deployer(
      services: services,
      firebaseCommand: firebaseCommand,
      gitCommand: gitCommand,
      fileHelper: fileHelper,
    );

    PostExpectation<Directory> whenGetDirectory() {
      return when(fileHelper.getDirectory(any));
    }

    PostExpectation<Future<String>> whenCreateGCloudProject() {
      return when(gcloudService.createProject());
    }

    PostExpectation<Future<String>> whenLoginToFirebase() {
      return when(firebaseCommand.login());
    }

    tearDown(() {
      reset(gcloudService);
      reset(flutterService);
      reset(npmService);
      reset(firebaseCommand);
      reset(gitCommand);
      reset(fileHelper);
      reset(directory);
    });

    test(
      "throws an ArgumentError if the given services is null",
      () {
        expect(
          () => Deployer(
            services: null,
            firebaseCommand: firebaseCommand,
            gitCommand: gitCommand,
            fileHelper: fileHelper,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given Firebase command is null",
      () {
        expect(
          () => Deployer(
            services: services,
            firebaseCommand: null,
            gitCommand: gitCommand,
            fileHelper: fileHelper,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given Git command is null",
      () {
        expect(
          () => Deployer(
            services: services,
            firebaseCommand: firebaseCommand,
            gitCommand: null,
            fileHelper: fileHelper,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given file helper is null",
      () {
        expect(
          () => Deployer(
            services: services,
            firebaseCommand: firebaseCommand,
            gitCommand: gitCommand,
            fileHelper: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      ".deploy() logs in to the GCloud",
      () async {
        whenGetDirectory().thenReturn(directory);
        await deployer.deploy();

        verify(gcloudService.login()).called(once);
      },
    );

    test(
      ".deploy() logs in to the GCloud before creating the GCloud project",
      () async {
        whenGetDirectory().thenReturn(directory);
        await deployer.deploy();

        verifyInOrder([
          gcloudService.login(),
          gcloudService.createProject(),
        ]);
      },
    );

    test(
      ".deploy() creates the GCloud project",
      () async {
        whenGetDirectory().thenReturn(directory);
        await deployer.deploy();

        verify(gcloudService.createProject()).called(once);
      },
    );

    test(
      ".deploy() logs in to the Firebase",
      () async {
        whenGetDirectory().thenReturn(directory);
        await deployer.deploy();

        verify(gcloudService.createProject()).called(once);
      },
    );

    test(
      ".deploy() logs in to the Firebase before adding the Firebase capabilities to the project",
      () async {
        whenGetDirectory().thenReturn(directory);
        await deployer.deploy();

        verifyInOrder([
          firebaseCommand.login(),
          firebaseCommand.addFirebase(any, any),
        ]);
      },
    );

    test(
      ".deploy() adds the Firebase capabilities to the created project",
      () async {
        whenCreateGCloudProject().thenAnswer((_) => Future.value(projectId));
        whenLoginToFirebase().thenAnswer((_) => Future.value(firebaseToken));
        whenGetDirectory().thenReturn(directory);

        await deployer.deploy();

        verify(firebaseCommand.addFirebase(projectId, firebaseToken))
            .called(once);
      },
    );

    test(
      ".deploy() adds the Firebase capabilities to the project before creating the web application",
      () async {
        whenGetDirectory().thenReturn(directory);
        await deployer.deploy();

        verifyInOrder([
          firebaseCommand.addFirebase(any, any),
          firebaseCommand.createWebApp(any, any),
        ]);
      },
    );

    test(
      ".deploy() creates the Firebase web application",
      () async {
        whenCreateGCloudProject().thenAnswer((_) => Future.value(projectId));
        whenLoginToFirebase().thenAnswer((_) => Future.value(firebaseToken));
        whenGetDirectory().thenReturn(directory);

        await deployer.deploy();

        verify(firebaseCommand.createWebApp(projectId, firebaseToken))
            .called(once);
      },
    );

    test(
      ".deploy() clones the Git repository",
      () async {
        whenGetDirectory().thenReturn(directory);

        await deployer.deploy();

        verify(gitCommand.clone(
          DeployConstants.repoURL,
          DeployConstants.tempDir,
        )).called(once);
      },
    );

    test(
      ".deploy() clones the Git repository before installing the npm dependencies",
      () async {
        whenGetDirectory().thenReturn(directory);
        await deployer.deploy();

        verifyInOrder([
          gitCommand.clone(DeployConstants.repoURL, DeployConstants.tempDir),
          npmService.installDependencies(DeployConstants.firebasePath),
          npmService.installDependencies(DeployConstants.firebaseFunctionsPath),
        ]);
      },
    );

    test(
      ".deploy() installs the npm dependencies",
      () async {
        whenGetDirectory().thenReturn(directory);

        await deployer.deploy();

        verify(npmService.installDependencies(DeployConstants.firebasePath))
            .called(once);
        verify(npmService.installDependencies(
          DeployConstants.firebaseFunctionsPath,
        )).called(once);
      },
    );

    test(
      ".deploy() clones the Git repository before building the Flutter application",
      () async {
        whenGetDirectory().thenReturn(directory);
        await deployer.deploy();

        verifyInOrder([
          gitCommand.clone(DeployConstants.repoURL, DeployConstants.tempDir),
          flutterService.build(DeployConstants.webPath),
        ]);
      },
    );

    test(
      ".deploy() builds the Flutter application",
      () async {
        whenGetDirectory().thenReturn(directory);

        await deployer.deploy();

        verify(flutterService.build(DeployConstants.webPath)).called(once);
      },
    );

    test(
      ".deploy() sets the default Firebase project",
      () async {
        whenCreateGCloudProject().thenAnswer((_) => Future.value(projectId));
        whenLoginToFirebase().thenAnswer((_) => Future.value(firebaseToken));
        whenGetDirectory().thenReturn(directory);

        await deployer.deploy();

        verify(
          firebaseCommand.setFirebaseProject(
            projectId,
            DeployConstants.webPath,
            firebaseToken,
          ),
        ).called(once);
      },
    );

    test(
      ".deploy() sets the default Firebase project before applying the Firebase target",
      () async {
        whenGetDirectory().thenReturn(directory);
        await deployer.deploy();

        verifyInOrder([
          firebaseCommand.setFirebaseProject(any, any, any),
          firebaseCommand.applyTarget(any, any, any, any),
        ]);
      },
    );

    test(
      ".deploy() applies the Firebase target",
      () async {
        whenCreateGCloudProject().thenAnswer((_) => Future.value(projectId));
        whenLoginToFirebase().thenAnswer((_) => Future.value(firebaseToken));
        whenGetDirectory().thenReturn(directory);

        await deployer.deploy();

        verify(
          firebaseCommand.applyTarget(
            projectId,
            DeployConstants.firebaseTarget,
            DeployConstants.webPath,
            firebaseToken,
          ),
        ).called(once);
      },
    );

    test(
      ".deploy() applies the Firebase target before deploying to the hosting",
      () async {
        whenGetDirectory().thenReturn(directory);
        await deployer.deploy();

        verifyInOrder([
          firebaseCommand.applyTarget(any, any, any, any),
          firebaseCommand.deployHosting(any, any, any),
        ]);
      },
    );

    test(
      ".deploy() builds the Flutter application before deploying to the hosting",
      () async {
        whenGetDirectory().thenReturn(directory);
        await deployer.deploy();

        verifyInOrder([
          flutterService.build(any),
          firebaseCommand.deployHosting(any, any, any),
        ]);
      },
    );

    test(
      ".deploy() deploys the target to the hosting",
      () async {
        whenCreateGCloudProject().thenAnswer((_) => Future.value(projectId));
        whenLoginToFirebase().thenAnswer((_) => Future.value(firebaseToken));
        whenGetDirectory().thenReturn(directory);

        await deployer.deploy();

        verify(
          firebaseCommand.deployHosting(
            DeployConstants.firebaseTarget,
            DeployConstants.webPath,
            firebaseToken,
          ),
        ).called(once);
      },
    );

    test(
      ".deploy() deploys a target to the hosting before deleting the temporary directory",
      () async {
        whenGetDirectory().thenReturn(directory);

        await deployer.deploy();

        verifyInOrder([
          firebaseCommand.deployHosting(any, any, any),
          directory.delete(recursive: true),
        ]);
      },
    );

    test(
      ".deploy() deletes the temporary directory",
      () async {
        whenGetDirectory().thenReturn(directory);

        await deployer.deploy();

        verify(directory.delete(recursive: true)).called(once);
      },
    );
  });
}

class _FileHelperMock extends Mock implements FileHelper {}
