// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/common/model/services.dart';
import 'package:cli/doctor/doctor.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_utils/firebase_command_mock.dart';
import '../test_utils/flutter_service_mock.dart';
import '../test_utils/gcloud_service_mock.dart';
import '../test_utils/git_service_mock.dart';
import '../test_utils/matchers.dart';
import '../test_utils/npm_service_mock.dart';
import '../test_utils/services_mock.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("Doctor", () {
    final stateError = StateError('test');
    final gcloudService = GCloudServiceMock();
    final flutterService = FlutterServiceMock();
    final firebaseCommand = FirebaseCommandMock();
    final gitService = GitServiceMock();
    final npmService = NpmServiceMock();
    final servicesMock = ServicesMock();
    final services = Services(
      flutterService: flutterService,
      gcloudService: gcloudService,
      gitService: gitService,
      npmService: npmService,
    );
    final doctor = Doctor(
      services: services,
      firebaseCommand: firebaseCommand,
    );

    tearDown(() {
      reset(gcloudService);
      reset(flutterService);
      reset(firebaseCommand);
      reset(npmService);
      reset(servicesMock);
      reset(gitService);
      reset(servicesMock);
    });

    test(
      "throws an ArgumentError if the given services is null",
      () {
        expect(
          () => Doctor(
            services: null,
            firebaseCommand: firebaseCommand,
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
        when(servicesMock.gitService).thenReturn(gitService);
        when(servicesMock.npmService).thenReturn(npmService);

        expect(
          () => Doctor(
            services: servicesMock,
            firebaseCommand: firebaseCommand,
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
        when(servicesMock.gitService).thenReturn(gitService);
        when(servicesMock.npmService).thenReturn(npmService);

        expect(
          () => Doctor(
            services: servicesMock,
            firebaseCommand: firebaseCommand,
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
        when(servicesMock.gitService).thenReturn(null);
        when(servicesMock.npmService).thenReturn(npmService);

        expect(
          () => Doctor(
            services: servicesMock,
            firebaseCommand: firebaseCommand,
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
            when(servicesMock.gitService).thenReturn(gitService);
            when(servicesMock.npmService).thenReturn(null);


        expect(
              () => Doctor(
            services: servicesMock,
            firebaseCommand: firebaseCommand,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given Firebase command is null",
      () {
        expect(
          () => Doctor(
            services: services,
            firebaseCommand: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      ".checkVersions() shows the Flutter version",
      () async {
        await doctor.checkVersions();

        verify(flutterService.version()).called(once);
      },
    );

    test(
      ".checkVersions() shows the Firebase version",
      () async {
        await doctor.checkVersions();

        verify(firebaseCommand.version()).called(once);
      },
    );

    test(
      ".checkVersions() shows the GCloud version",
      () async {
        await doctor.checkVersions();

        verify(gcloudService.version()).called(once);
      },
    );

    test(
      ".checkVersions() shows the Git version",
      () async {
        await doctor.checkVersions();

        verify(gitService.version()).called(once);
      },
    );

    test(
      ".checkVersions() shows the Npm version",
      () async {
        await doctor.checkVersions();

        verify(npmService.version()).called(once);
      },
    );

    test(
      ".checkVersions() proceeds if GCloud service throws during the version showing",
      () async {
        when(gcloudService.version())
            .thenAnswer((_) => Future.error(stateError));

        await doctor.checkVersions();

        verify(gcloudService.version()).called(once);
        verify(flutterService.version()).called(once);
        verify(firebaseCommand.version()).called(once);
        verify(npmService.version()).called(once);
        verify(gitService.version()).called(once);
      },
    );

    test(
      ".checkVersions() proceeds if Flutter service throws during the version showing",
      () async {
        when(flutterService.version())
            .thenAnswer((_) => Future.error(stateError));

        await doctor.checkVersions();

        verify(gcloudService.version()).called(once);
        verify(flutterService.version()).called(once);
        verify(firebaseCommand.version()).called(once);
        verify(npmService.version()).called(once);
        verify(gitService.version()).called(once);
      },
    );

    test(
      ".checkVersions() proceeds if Firebase command throws during the version showing",
      () async {
        when(firebaseCommand.version())
            .thenAnswer((_) => Future.error(stateError));

        await doctor.checkVersions();

        verify(gcloudService.version()).called(once);
        verify(flutterService.version()).called(once);
        verify(firebaseCommand.version()).called(once);
        verify(npmService.version()).called(once);
        verify(gitService.version()).called(once);
      },
    );

    test(
      ".checkVersions() proceeds if Git service throws during the version showing",
      () async {
        when(gitService.version()).thenAnswer((_) => Future.error(stateError));

        await doctor.checkVersions();

        verify(gcloudService.version()).called(once);
        verify(flutterService.version()).called(once);
        verify(firebaseCommand.version()).called(once);
        verify(gitService.version()).called(once);
      },
    );

    test(
      ".checkVersions() proceeds if Npm service throws during the version showing",
          () async {
        when(npmService.version()).thenAnswer((_) => Future.error(stateError));

        await doctor.checkVersions();

        verify(gcloudService.version()).called(once);
        verify(flutterService.version()).called(once);
        verify(firebaseCommand.version()).called(once);
        verify(gitService.version()).called(once);
        verify(npmService.version()).called(once);
      },
    );
  });
}
