// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/common/model/services.dart';
import 'package:cli/doctor/doctor.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_utils/firebase_command_mock.dart';
import '../test_utils/flutter_service_mock.dart';
import '../test_utils/gcloud_service_mock.dart';
import '../test_utils/git_command_mock.dart';
import '../test_utils/matchers.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("Doctor", () {
    final stateError = StateError('test');
    final gcloudService = GCloudServiceMock();
    final flutterService = FlutterServiceMock();
    final firebaseCommand = FirebaseCommandMock();
    final gitCommand = GitCommandMock();
    final services = Services(
      flutterService: flutterService,
      gcloudService: gcloudService,
    );
    final doctor = Doctor(
      services: services,
      firebaseCommand: firebaseCommand,
      gitCommand: gitCommand,
    );

    tearDown(() {
      reset(gcloudService);
      reset(flutterService);
      reset(firebaseCommand);
      reset(gitCommand);
    });

    test(
      "throws an ArgumentError if the given services is null",
      () {
        expect(
          () => Doctor(
            services: null,
            firebaseCommand: firebaseCommand,
            gitCommand: gitCommand,
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
            gitCommand: gitCommand,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given Git command is null",
      () {
        expect(
          () => Doctor(
            services: services,
            firebaseCommand: firebaseCommand,
            gitCommand: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      ".checkVersions() shows the Flutter CLI version",
      () async {
        await doctor.checkVersions();

        verify(flutterService.version()).called(once);
      },
    );

    test(
      ".checkVersions() shows the Firebase CLI version",
      () async {
        await doctor.checkVersions();

        verify(firebaseCommand.version()).called(once);
      },
    );

    test(
      ".checkVersions() shows the GCloud CLI version",
      () async {
        await doctor.checkVersions();

        verify(gcloudService.version()).called(once);
      },
    );

    test(
      ".checkVersions() shows the Git CLI version",
      () async {
        await doctor.checkVersions();

        verify(gitCommand.version()).called(once);
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
        verify(gitCommand.version()).called(once);
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
        verify(gitCommand.version()).called(once);
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
        verify(gitCommand.version()).called(once);
      },
    );

    test(
      ".checkVersions() proceeds if Git command throws during the version showing",
          () async {
        when(gitCommand.version())
            .thenAnswer((_) => Future.error(stateError));

        await doctor.checkVersions();

        verify(gcloudService.version()).called(once);
        verify(flutterService.version()).called(once);
        verify(firebaseCommand.version()).called(once);
        verify(gitCommand.version()).called(once);
      },
    );
  });
}
