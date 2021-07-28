// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/cli/doctor/doctor.dart';
import 'package:cli/cli/doctor/factory/doctor_factory.dart';
import 'package:cli/common/model/services/services.dart';
import 'package:cli/util/dependencies/dependencies.dart';
import 'package:cli/util/dependencies/dependency.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../test_utils/matchers.dart';
import '../../../test_utils/mocks/dependencies_factory_mock.dart';
import '../../../test_utils/mocks/firebase_service_mock.dart';
import '../../../test_utils/mocks/flutter_service_mock.dart';
import '../../../test_utils/mocks/gcloud_service_mock.dart';
import '../../../test_utils/mocks/git_service_mock.dart';
import '../../../test_utils/mocks/npm_service_mock.dart';
import '../../../test_utils/mocks/sentry_service_mock.dart';
import '../../../test_utils/mocks/services_factory_mock.dart';

void main() {
  group("DoctorFactory", () {
    const dependency = Dependency(recommendedVersion: '1', installUrl: 'url');
    const dependenciesMap = {'service': dependency};
    final servicesFactory = ServicesFactoryMock();
    final dependenciesFactory = DependenciesFactoryMock();
    final doctorFactory = DoctorFactory(servicesFactory, dependenciesFactory);
    final flutterService = FlutterServiceMock();
    final gcloudService = GCloudServiceMock();
    final npmService = NpmServiceMock();
    final gitService = GitServiceMock();
    final firebaseService = FirebaseServiceMock();
    final sentryService = SentryServiceMock();
    final services = Services(
      flutterService: flutterService,
      gcloudService: gcloudService,
      npmService: npmService,
      gitService: gitService,
      firebaseService: firebaseService,
      sentryService: sentryService,
    );
    final dependencies = Dependencies(dependenciesMap);

    PostExpectation<Services> whenCreateServices() {
      return when(servicesFactory.create());
    }

    PostExpectation<Dependencies> whenCreateDependencies() {
      return when(dependenciesFactory.create(any));
    }

    tearDown(() {
      reset(servicesFactory);
      reset(dependenciesFactory);
      reset(gcloudService);
      reset(flutterService);
      reset(gitService);
      reset(npmService);
      reset(firebaseService);
      reset(sentryService);
    });

    test(
      "throws an ArgumentError if the given services factory is null",
      () {
        expect(
          () => DoctorFactory(null, dependenciesFactory),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given dependencies factory is null",
      () {
        expect(
          () => DoctorFactory(servicesFactory, null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".create() creates a Services instance using the given services factory",
      () {
        whenCreateServices().thenReturn(services);

        doctorFactory.create();

        verify(servicesFactory.create()).called(once);
      },
    );

    test(
      ".create() creates a Dependencies instance using the given dependencies factory",
      () {
        whenCreateServices().thenReturn(services);
        whenCreateDependencies().thenReturn(dependencies);

        doctorFactory.create();

        verify(dependenciesFactory.create(any)).called(once);
      },
    );

    test(
      ".create() successfully creates a Doctor instance",
      () {
        whenCreateServices().thenReturn(services);

        final doctor = doctorFactory.create();

        expect(doctor, isA<Doctor>());
      },
    );
  });
}
