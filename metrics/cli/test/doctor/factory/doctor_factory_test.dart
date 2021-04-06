// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/common/model/services.dart';
import 'package:cli/doctor/doctor.dart';
import 'package:cli/doctor/factory/doctor_factory.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../test_utils/matchers.dart';
import '../../test_utils/services_factory_mock.dart';
import '../../test_utils/services_mock.dart';

void main() {
  group("DoctorFactory", () {
    final servicesFactory = ServicesFactoryMock();
    final services = ServicesMock();
    final doctorFactory = DoctorFactory(servicesFactory);

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
