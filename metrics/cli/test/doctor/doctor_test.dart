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
    final gcloudService = GCloudServiceMock();
    final flutterService = FlutterServiceMock();
    final firebaseService = FirebaseCommandMock();
    final gitService = GitCommandMock();
    final services = Services(
      flutterService: flutterService,
      gcloudService: gcloudService,
    );
    final doctor = Doctor(
      services: services,
      firebaseCommand: firebaseService,
      gitCommand: gitService,
    );

    tearDown(() {
      reset(gcloudService);
      reset(flutterService);
      reset(firebaseService);
      reset(gitService);
    });

    test(
      "throws an ArgumentError if the given services is null",
      () {
        expect(
          () => Doctor(
            services: null,
            firebaseCommand: firebaseService,
            gitCommand: gitService,
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
            gitCommand: gitService,
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
            firebaseCommand: firebaseService,
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

        verify(firebaseService.version()).called(once);
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

        verify(gitService.version()).called(once);
      },
    );
  });
}
