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
    const firebasePath = DeployConstants.firebasePath;
    const firebaseFunctionsPath = DeployConstants.firebaseFunctionsPath;
    const firebaseTarget = DeployConstants.firebaseTarget;
    const webPath = DeployConstants.webPath;
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

    PostExpectation<Directory> whenGetDirectory() {
      return when(fileHelper.getDirectory(any));
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
      "throws an ArgumentError if the given file helper is null",
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
          firebaseService.login(),
          firebaseService.createWebApp(any),
        ]);
      },
    );

    test(
      ".deploy() adds the Firebase capabilities to the created project",
      () async {
        whenCreateGCloudProject().thenAnswer((_) => Future.value(projectId));
        whenGetDirectory().thenReturn(directory);

        await deployer.deploy();

        verify(firebaseService.createWebApp(projectId)).called(once);
      },
    );

    test(
      ".deploy() clones the Git repository",
      () async {
        whenGetDirectory().thenReturn(directory);

        await deployer.deploy();

        verify(gitService.checkout(repoURL, tempDir)).called(once);
      },
    );

    test(
      ".deploy() clones the Git repository before building the Flutter application",
      () async {
        whenGetDirectory().thenReturn(directory);
        await deployer.deploy();

        verifyInOrder([
          gitService.checkout(repoURL, tempDir),
          flutterService.build(webPath),
        ]);
      },
    );

    test(
      ".deploy() installs the npm dependencies",
      () async {
        whenGetDirectory().thenReturn(directory);

        await deployer.deploy();

        verify(npmService.installDependencies(firebasePath)).called(once);
        verify(npmService.installDependencies(firebaseFunctionsPath))
            .called(once);
      },
    );

    test(
      ".deploy() builds the Flutter application",
      () async {
        whenGetDirectory().thenReturn(directory);

        await deployer.deploy();

        verify(flutterService.build(webPath)).called(once);
      },
    );

    test(
      ".deploy() installs the npm dependencies in the Firebase folder before deploying to the Firebase",
      () async {
        whenGetDirectory().thenReturn(directory);
        await deployer.deploy();

        verifyInOrder([
          npmService.installDependencies(firebasePath),
          firebaseService.deployFirebase(any, any),
        ]);
      },
    );

    test(
      ".deploy() installs the npm dependencies to the functions folder before deploying to the Firebase",
      () async {
        whenGetDirectory().thenReturn(directory);
        await deployer.deploy();

        verifyInOrder([
          npmService.installDependencies(firebaseFunctionsPath),
          firebaseService.deployFirebase(any, any),
        ]);
      },
    );

    test(
      ".deploy() deploys Firebase rules, indexes, and functions to the Firebase",
      () async {
        whenCreateGCloudProject().thenAnswer((_) => Future.value(projectId));
        whenGetDirectory().thenReturn(directory);

        await deployer.deploy();

        verify(firebaseService.deployFirebase(projectId, firebasePath))
            .called(once);
      },
    );

    test(
      ".deploy() deploys Firebase rules, indexes, and functions before deploying to the hosting",
      () async {
        whenGetDirectory().thenReturn(directory);
        await deployer.deploy();

        verifyInOrder([
          firebaseService.deployFirebase(any, any),
          firebaseService.deployHosting(any, any, any),
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
          firebaseService.deployHosting(any, any, any),
        ]);
      },
    );

    test(
      ".deploy() deploys the target to the hosting",
      () async {
        whenCreateGCloudProject().thenAnswer((_) => Future.value(projectId));
        whenGetDirectory().thenReturn(directory);

        await deployer.deploy();

        verify(firebaseService.deployHosting(
          projectId,
          firebaseTarget,
          webPath,
        )).called(once);
      },
    );

    test(
      ".deploy() deploys a target to the hosting before deleting the temporary directory",
      () async {
        whenGetDirectory().thenReturn(directory);

        await deployer.deploy();

        verifyInOrder([
          firebaseService.deployHosting(any, any, any),
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
