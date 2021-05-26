// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/cli/command/doctor_command.dart';
import 'package:cli/cli/doctor/doctor.dart';
import 'package:cli/cli/doctor/factory/doctor_factory.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../test_utils/matchers.dart';

void main() {
  group("DoctorCommand", () {
    final doctorFactory = _DoctorFactoryMock();
    final doctor = _DoctorMock();
    final doctorCommand = DoctorCommand(doctorFactory);

    PostExpectation<Doctor> whenCreateDoctor() {
      return when(doctorFactory.create());
    }

    tearDown(() {
      reset(doctorFactory);
      reset(doctor);
    });

    test(
      "throws an ArgumentError if the given doctor factory is null",
      () {
        expect(
          () => DoctorCommand(null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".name equals to the 'doctor'",
      () {
        expect(doctorCommand.name, equals('doctor'));
      },
    );

    test(
      ".description is not empty",
      () {
        final description = doctorCommand.description;

        expect(description, isNotEmpty);
      },
    );

    test(
      ".run() creates doctor using the given doctor factory",
      () async {
        whenCreateDoctor().thenReturn(doctor);

        await doctorCommand.run();

        verify(doctorFactory.create()).called(once);
      },
    );

    test(
      ".run() uses the doctor to check versions",
      () async {
        whenCreateDoctor().thenReturn(doctor);

        await doctorCommand.run();

        verify(doctor.checkVersions()).called(once);
      },
    );
  });
}

class _DoctorMock extends Mock implements Doctor {}

class _DoctorFactoryMock extends Mock implements DoctorFactory {}
