// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/cli/doctor/doctor.dart';
import 'package:cli/cli/doctor/model/doctor_target_validation_result.dart';
import 'package:cli/common/model/services/services.dart';
import 'package:cli/services/common/service/model/service_name.dart';
import 'package:cli/util/dependencies/dependency.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../test_utils/matchers.dart';
import '../../test_utils/mocks/dependencies_mock.dart';
import '../../test_utils/mocks/firebase_service_mock.dart';
import '../../test_utils/mocks/flutter_service_mock.dart';
import '../../test_utils/mocks/gcloud_service_mock.dart';
import '../../test_utils/mocks/git_service_mock.dart';
import '../../test_utils/mocks/npm_service_mock.dart';
import '../../test_utils/mocks/process_result_mock.dart';
import '../../test_utils/mocks/sentry_service_mock.dart';
import '../../test_utils/mocks/services_mock.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("Doctor", () {
    const recommendedVersion = '1';
    const installUrl = 'url';
    const dependency = Dependency(
      recommendedVersion: recommendedVersion,
      installUrl: installUrl,
    );
    const validationTarget = ValidationTarget(
      name: 'flutter',
      description: 'CLI',
    );
    final stateError = StateError('test');
    final flutterService = FlutterServiceMock();
    final gcloudService = GCloudServiceMock();
    final npmService = NpmServiceMock();
    final gitService = GitServiceMock();
    final firebaseService = FirebaseServiceMock();
    final sentryService = SentryServiceMock();
    final servicesMock = ServicesMock();
    final services = Services(
      flutterService: flutterService,
      gcloudService: gcloudService,
      npmService: npmService,
      gitService: gitService,
      firebaseService: firebaseService,
      sentryService: sentryService,
    );
    final dependencies = DependenciesMock();
    final doctor = Doctor(
      services: services,
      dependencies: dependencies,
    );
    final processResult = ProcessResultMock();

    setUp(() {
      when(servicesMock.flutterService).thenReturn(flutterService);
      when(servicesMock.gcloudService).thenReturn(gcloudService);
      when(servicesMock.npmService).thenReturn(npmService);
      when(servicesMock.gitService).thenReturn(gitService);
      when(servicesMock.firebaseService).thenReturn(firebaseService);
      when(servicesMock.sentryService).thenReturn(sentryService);
    });

    PostExpectation<Dependency> whenGetDependency() {
      when(flutterService.serviceName).thenReturn(ServiceName.flutter);
      when(gcloudService.serviceName).thenReturn(ServiceName.gcloud);
      when(npmService.serviceName).thenReturn(ServiceName.npm);
      when(gitService.serviceName).thenReturn(ServiceName.git);
      when(firebaseService.serviceName).thenReturn(ServiceName.firebase);
      when(sentryService.serviceName).thenReturn(ServiceName.sentry);

      return when(dependencies.getFor(any));
    }

    tearDown(() {
      reset(flutterService);
      reset(gcloudService);
      reset(npmService);
      reset(gitService);
      reset(firebaseService);
      reset(sentryService);
      reset(servicesMock);
    });

    test(
      "throws an ArgumentError if the given services is null",
      () {
        expect(
          () => Doctor(
            services: null,
            dependencies: dependencies,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given dependencies is null",
      () {
        expect(
          () => Doctor(
            services: services,
            dependencies: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the Flutter service in the given services is null",
      () {
        when(servicesMock.flutterService).thenReturn(null);

        expect(() => Doctor(services: servicesMock), throwsArgumentError);
      },
    );

    test(
      "throws an ArgumentError if the GCloud service in the given services is null",
      () {
        when(servicesMock.gcloudService).thenReturn(null);

        expect(() => Doctor(services: servicesMock), throwsArgumentError);
      },
    );

    test(
      "throws an ArgumentError if the Npm service in the given services is null",
      () {
        when(servicesMock.npmService).thenReturn(null);

        expect(() => Doctor(services: servicesMock), throwsArgumentError);
      },
    );

    test(
      "throws an ArgumentError if the Git service in the given services is null",
      () {
        when(servicesMock.gitService).thenReturn(null);

        expect(() => Doctor(services: servicesMock), throwsArgumentError);
      },
    );

    test(
      "throws an ArgumentError if the Firebase service in the given services is null",
      () {
        when(servicesMock.firebaseService).thenReturn(null);

        expect(() => Doctor(services: servicesMock), throwsArgumentError);
      },
    );

    test(
      "throws an ArgumentError if the Sentry service in the given services is null",
      () {
        when(servicesMock.sentryService).thenReturn(null);

        expect(() => Doctor(services: servicesMock), throwsArgumentError);
      },
    );

    test(
      ".checkVersions() shows the Flutter version",
      () async {
        whenGetDependency().thenReturn(dependency);

        await doctor.checkVersions();

        verify(flutterService.version()).called(once);
      },
    );

    test(
      ".checkVersions() shows the Firebase version",
      () async {
        whenGetDependency().thenReturn(dependency);

        await doctor.checkVersions();

        verify(firebaseService.version()).called(once);
      },
    );

    test(
      ".checkVersions() shows the GCloud version",
      () async {
        whenGetDependency().thenReturn(dependency);

        await doctor.checkVersions();

        verify(gcloudService.version()).called(once);
      },
    );

    test(
      ".checkVersions() shows the Git version",
      () async {
        whenGetDependency().thenReturn(dependency);

        await doctor.checkVersions();

        verify(gitService.version()).called(once);
      },
    );

    test(
      ".checkVersions() shows the Npm version",
      () async {
        whenGetDependency().thenReturn(dependency);

        await doctor.checkVersions();

        verify(npmService.version()).called(once);
      },
    );

    test(
      ".checkVersions() shows the Sentry version",
      () async {
        whenGetDependency().thenReturn(dependency);

        await doctor.checkVersions();

        verify(npmService.version()).called(once);
      },
    );

    test(
      ".checkVersions() returns an instance of the ValidationResult",
      () async {
        whenGetDependency().thenReturn(dependency);

        final result = await doctor.checkVersions();

        expect(result, isA<ValidationResult>());
      },
    );

    test(
      ".checkVersions() proceeds if Flutter service throws during the version showing",
      () async {
        whenGetDependency().thenReturn(dependency);
        when(
          flutterService.version(),
        ).thenAnswer((_) => Future.error(stateError));

        await doctor.checkVersions();

        verify(gcloudService.version()).called(once);
        verify(flutterService.version()).called(once);
        verify(firebaseService.version()).called(once);
        verify(npmService.version()).called(once);
        verify(gitService.version()).called(once);
      },
    );

    test(
      ".checkVersions() proceeds if GCloud service throws during the version showing",
      () async {
        whenGetDependency().thenReturn(dependency);
        when(
          gcloudService.version(),
        ).thenAnswer((_) => Future.error(stateError));

        await doctor.checkVersions();

        verify(gcloudService.version()).called(once);
        verify(flutterService.version()).called(once);
        verify(firebaseService.version()).called(once);
        verify(npmService.version()).called(once);
        verify(gitService.version()).called(once);
      },
    );

    test(
      ".checkVersions() proceeds if Npm service throws during the version showing",
      () async {
        whenGetDependency().thenReturn(dependency);
        when(npmService.version()).thenAnswer((_) => Future.error(stateError));

        await doctor.checkVersions();

        verify(gcloudService.version()).called(once);
        verify(flutterService.version()).called(once);
        verify(firebaseService.version()).called(once);
        verify(npmService.version()).called(once);
        verify(gitService.version()).called(once);
      },
    );

    test(
      ".checkVersions() proceeds if Git service throws during the version showing",
      () async {
        whenGetDependency().thenReturn(dependency);
        when(gitService.version()).thenAnswer((_) => Future.error(stateError));

        await doctor.checkVersions();

        verify(gcloudService.version()).called(once);
        verify(flutterService.version()).called(once);
        verify(firebaseService.version()).called(once);
        verify(npmService.version()).called(once);
        verify(gitService.version()).called(once);
      },
    );

    test(
      ".checkVersions() proceeds if Firebase service throws during the version showing",
      () async {
        whenGetDependency().thenReturn(dependency);
        when(
          firebaseService.version(),
        ).thenAnswer((_) => Future.error(stateError));

        await doctor.checkVersions();

        verify(gcloudService.version()).called(once);
        verify(flutterService.version()).called(once);
        verify(firebaseService.version()).called(once);
        verify(npmService.version()).called(once);
        verify(gitService.version()).called(once);
      },
    );

    test(
      ".checkVersions() proceeds if Sentry service throws during the version showing",
      () async {
        whenGetDependency().thenReturn(dependency);
        when(
          sentryService.version(),
        ).thenAnswer((_) => Future.error(stateError));

        await doctor.checkVersions();

        verify(gcloudService.version()).called(once);
        verify(flutterService.version()).called(once);
        verify(firebaseService.version()).called(once);
        verify(npmService.version()).called(once);
        verify(gitService.version()).called(once);
      },
    );

    test(
      ".checkVersions() returns a successful validation result build by the validation result builder if the current version is valid and command doesn't have error",
      () async {
        final expectedResult = DoctorTargetValidationResult.successful(
          validationTarget,
          recommendedVersion,
        );
        whenGetDependency().thenReturn(dependency);
        when(flutterService.version())
            .thenAnswer((_) => Future.value(processResult));
        when(processResult.stdout).thenReturn(recommendedVersion);
        when(processResult.stderr).thenReturn(null);

        final result = await doctor.checkVersions();
        final validationTargetResult = result.results[validationTarget];

        expect(validationTargetResult, equals(expectedResult));
      },
    );

    test(
      ".checkVersions() returns a failure validation result build by the validation result builder if the version command throws an error",
      () async {
        final expectedResult = DoctorTargetValidationResult.failure(
          validationTarget,
          recommendedVersion,
          installUrl,
          stateError,
        );
        whenGetDependency().thenReturn(dependency);
        when(
          flutterService.version(),
        ).thenAnswer((_) => Future.error(stateError));

        final result = await doctor.checkVersions();
        final validationTargetResult = result.results[validationTarget];

        expect(validationTargetResult, equals(expectedResult));
      },
    );

    test(
      ".checkVersions() returns a warning validation result build by the validation result builder if the current version is not valid",
      () async {
        const currentVersion = '2';
        final expectedResult = DoctorTargetValidationResult.warning(
          validationTarget,
          currentVersion,
          recommendedVersion: recommendedVersion,
          installUrl: installUrl,
          error: null,
        );
        whenGetDependency().thenReturn(dependency);
        when(flutterService.version())
            .thenAnswer((_) => Future.value(processResult));
        when(processResult.stdout).thenReturn(currentVersion);
        when(processResult.stderr).thenReturn(null);

        final result = await doctor.checkVersions();
        final validationTargetResult = result.results[validationTarget];

        expect(validationTargetResult, equals(expectedResult));
      },
    );

    test(
      ".checkVersions() returns a warning validation result build by the validation result builder if the version command has an error",
      () async {
        const currentVersion = recommendedVersion;
        const error = 'error';
        final expectedResult = DoctorTargetValidationResult.warning(
          validationTarget,
          currentVersion,
          recommendedVersion: null,
          installUrl: null,
          error: error,
        );
        whenGetDependency().thenReturn(dependency);
        when(flutterService.version())
            .thenAnswer((_) => Future.value(processResult));
        when(processResult.stdout).thenReturn(currentVersion);
        when(processResult.stderr).thenReturn(error);

        final result = await doctor.checkVersions();
        final validationTargetResult = result.results[validationTarget];

        expect(validationTargetResult, equals(expectedResult));
      },
    );
  });
}
