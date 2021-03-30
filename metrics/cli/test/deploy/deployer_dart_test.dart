// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:cli/cli/firebase/firebase_command.dart';
import 'package:cli/cli/git/git_command.dart';
import 'package:cli/common/model/services.dart';
import 'package:cli/deploy/constants/deploy_constants.dart';
import 'package:cli/deploy/deployer.dart';
import 'package:cli/helper/file_helper.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_utils/directory_mock.dart';
import '../test_utils/flutter_service_mock.dart';
import '../test_utils/gcloud_service_mock.dart';
import '../test_utils/matchers.dart';

void main() {
  group("Deployer", () {
    final gcloudService = GCloudServiceMock();
    final flutterService = FlutterServiceMock();
    final firebaseCommand = _FirebaseCommandMock();
    final gitCommand = _GitCommandMock();
    final fileHelper = _FileHelperMock();
    final directory = DirectoryMock();
    final services = Services(
      flutterService: flutterService,
      gcloudService: gcloudService,
    );
    final deployer = Deployer(
      services,
      firebaseCommand,
      gitCommand,
      fileHelper,
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
      reset(firebaseCommand);
      reset(gitCommand);
      reset(fileHelper);
      reset(directory);
    });

    test(
      "throws an ArgumentError if the given services is null",
      () {
        expect(
          () => Deployer(null, firebaseCommand, gitCommand, fileHelper),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given firebase command is null",
      () {
        expect(
          () => Deployer(services, null, gitCommand, fileHelper),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given git command is null",
      () {
        expect(
          () => Deployer(services, firebaseCommand, null, fileHelper),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given file helper is null",
      () {
        expect(
          () => Deployer(services, firebaseCommand, gitCommand, null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".deploy() logs in to the GCloud",
      () async {
        whenGetDirectory().thenAnswer((_) => directory);
        await deployer.deploy();

        verify(gcloudService.login()).called(once);
      },
    );

    test(
      ".deploy() logs in to the GCloud before creating the GCloud project",
      () async {
        whenGetDirectory().thenAnswer((_) => directory);
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
        whenGetDirectory().thenAnswer((_) => directory);
        await deployer.deploy();

        verify(gcloudService.createProject()).called(once);
      },
    );

    test(
      ".deploy() creates the GCloud project before login to the Firebase",
      () async {
        whenGetDirectory().thenAnswer((_) => directory);
        await deployer.deploy();

        verifyInOrder([
          gcloudService.createProject(),
          firebaseCommand.login(),
        ]);
      },
    );

    test(
      ".deploy() logs in to the Firebase",
      () async {
        whenGetDirectory().thenAnswer((_) => directory);
        await deployer.deploy();

        verify(gcloudService.createProject()).called(once);
      },
    );

    test(
      ".deploy() logs in to the Firebase before adding the firebase capabilities to the project",
      () async {
        whenGetDirectory().thenAnswer((_) => directory);
        await deployer.deploy();

        verifyInOrder([
          firebaseCommand.login(),
          firebaseCommand.addFirebase(any, any),
        ]);
      },
    );

    test(
      ".deploy() adds the firebase capabilities to the created project",
      () async {
        const projectId = 'testId';
        const firebaseToken = 'testToken';
        whenCreateGCloudProject().thenAnswer((_) => Future.value(projectId));
        whenLoginToFirebase().thenAnswer((_) => Future.value(firebaseToken));
        whenGetDirectory().thenAnswer((_) => directory);

        await deployer.deploy();

        verify(firebaseCommand.addFirebase(projectId, firebaseToken))
            .called(once);
      },
    );

    test(
      ".deploy() adds the firebase capabilities to the project before creating the web application",
      () async {
        whenGetDirectory().thenAnswer((_) => directory);
        await deployer.deploy();

        verifyInOrder([
          firebaseCommand.addFirebase(any, any),
          firebaseCommand.createWebApp(any, any),
        ]);
      },
    );

    test(
      ".deploy() creates the firebase web application",
      () async {
        const projectId = 'testId';
        const firebaseToken = 'testToken';
        whenCreateGCloudProject().thenAnswer((_) => Future.value(projectId));
        whenLoginToFirebase().thenAnswer((_) => Future.value(firebaseToken));
        whenGetDirectory().thenAnswer((_) => directory);

        await deployer.deploy();

        verify(firebaseCommand.createWebApp(projectId, firebaseToken))
            .called(once);
      },
    );

    test(
      ".deploy() creates the firebase web application before cloning git repository",
      () async {
        whenGetDirectory().thenAnswer((_) => directory);
        await deployer.deploy();

        verifyInOrder([
          firebaseCommand.createWebApp(any, any),
          gitCommand.clone(any, any),
        ]);
      },
    );

    test(
      ".deploy() clones the git repository",
      () async {
        whenGetDirectory().thenAnswer((_) => directory);

        await deployer.deploy();

        verify(gitCommand.clone(
          DeployConstants.repoURL,
          DeployConstants.tempDir,
        )).called(once);
      },
    );

    test(
      ".deploy() clones the git repository before building the flutter application",
      () async {
        whenGetDirectory().thenAnswer((_) => directory);
        await deployer.deploy();

        verifyInOrder([
          gitCommand.clone(DeployConstants.repoURL, DeployConstants.tempDir),
          flutterService.build(DeployConstants.webPath),
        ]);
      },
    );

    test(
      ".deploy() builds the flutter application",
      () async {
        whenGetDirectory().thenAnswer((_) => directory);

        await deployer.deploy();

        verify(flutterService.build(DeployConstants.webPath)).called(once);
      },
    );

    test(
      ".deploy() builds the flutter application before setting the default Firebase project",
      () async {
        whenGetDirectory().thenAnswer((_) => directory);
        await deployer.deploy();

        verifyInOrder([
          flutterService.build(DeployConstants.webPath),
          firebaseCommand.setFirebaseProject(any, any, any),
        ]);
      },
    );

    test(
      ".deploy() sets the default Firebase project",
      () async {
        const projectId = 'testId';
        const firebaseToken = 'testToken';
        whenCreateGCloudProject().thenAnswer((_) => Future.value(projectId));
        whenLoginToFirebase().thenAnswer((_) => Future.value(firebaseToken));
        whenGetDirectory().thenAnswer((_) => directory);

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
        whenGetDirectory().thenAnswer((_) => directory);
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
        const projectId = 'testId';
        const firebaseToken = 'testToken';
        whenCreateGCloudProject().thenAnswer((_) => Future.value(projectId));
        whenLoginToFirebase().thenAnswer((_) => Future.value(firebaseToken));
        whenGetDirectory().thenAnswer((_) => directory);

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
        whenGetDirectory().thenAnswer((_) => directory);
        await deployer.deploy();

        verifyInOrder([
          firebaseCommand.applyTarget(any, any, any, any),
          firebaseCommand.deployHosting(any, any, any),
        ]);
      },
    );

    test(
      ".deploy() deploys the target to the hosting",
      () async {
        const projectId = 'testId';
        const firebaseToken = 'testToken';
        whenCreateGCloudProject().thenAnswer((_) => Future.value(projectId));
        whenLoginToFirebase().thenAnswer((_) => Future.value(firebaseToken));
        whenGetDirectory().thenAnswer((_) => directory);

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
      ".deploy() deploys a target to the hosting before getting the temporary directory",
      () async {
        whenGetDirectory().thenAnswer((_) => directory);
        await deployer.deploy();

        verifyInOrder([
          firebaseCommand.deployHosting(any, any, any),
          fileHelper.getDirectory(any),
        ]);
      },
    );

    test(
      ".deploy() gets the temporary directory",
      () async {
        whenGetDirectory().thenAnswer((_) => directory);

        await deployer.deploy();

        verify(fileHelper.getDirectory(DeployConstants.tempDir)).called(once);
      },
    );

    test(
      ".deploy() gets the temporary directory before deleting it",
      () async {
        whenGetDirectory().thenAnswer((_) => directory);
        await deployer.deploy();

        verifyInOrder([
          fileHelper.getDirectory(any),
          directory.delete(recursive: true),
        ]);
      },
    );

    test(
      ".deploy() deletes the temporary directory",
      () async {
        whenGetDirectory().thenAnswer((_) => directory);

        await deployer.deploy();

        verify(directory.delete(recursive: true)).called(once);
      },
    );
  });
}

class _FileHelperMock extends Mock implements FileHelper {}

class _GitCommandMock extends Mock implements GitCommand {}

class _FirebaseCommandMock extends Mock implements FirebaseCommand {}
