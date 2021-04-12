// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/common/model/services.dart';
import 'package:cli/doctor/doctor.dart';
import 'package:cli/doctor/factory/doctor_factory.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../test_utils/flutter_service_mock.dart';
import '../../test_utils/gcloud_service_mock.dart';
import '../../test_utils/git_service_mock.dart';
import '../../test_utils/matchers.dart';
import '../../test_utils/npm_service_mock.dart';
import '../../test_utils/services_factory_mock.dart';

void main() {
  group("DoctorFactory", () {
    final servicesFactory = ServicesFactoryMock();
    final doctorFactory = DoctorFactory(servicesFactory);
    final flutterService = FlutterServiceMock();
    final gcloudService = GCloudServiceMock();
    final npmService = NpmServiceMock();
    final gitService = GitServiceMock();
    final services = Services(
      flutterService: flutterService,
      gcloudService: gcloudService,
      npmService: npmService,
      gitService: gitService,
    );

    PostExpectation<Services> whenCreateServices() {
      return when(servicesFactory.create());
    }

    test(
      "throws an ArgumentError if the given services factory is null",
      () {
        expect(
          () => DoctorFactory(null),
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
      ".create() successfully creates a Doctor instance",
      () {
        whenCreateServices().thenReturn(services);

        final doctor = doctorFactory.create();

        expect(doctor, isA<Doctor>());
      },
    );
  });
}
