// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/cli/doctor/model/doctor_validation_conclusion.dart';
import 'package:test/test.dart';

void main() {
  group("DoctorValidationConclusion", () {
    final successfulConclusion = DoctorValidationConclusion.successful();
    final failureConclusion = DoctorValidationConclusion.failure();
    final warningConclusion = DoctorValidationConclusion.warning();

    test(
      ".successful() creates an instance with the 'successful' name and '+' indicator",
      () {
        const expectedName = 'successful';
        const expectedIndicator = '+';

        expect(successfulConclusion.name, equals(expectedName));
        expect(successfulConclusion.indicator, equals(expectedIndicator));
      },
    );

    test(
      ".failure() creates an instance with the 'failure' name and '-' indicator",
      () {
        const expectedName = 'failure';
        const expectedIndicator = '-';

        expect(failureConclusion.name, equals(expectedName));
        expect(failureConclusion.indicator, equals(expectedIndicator));
      },
    );

    test(
      ".warning() creates an instance with the 'warning' name and '!' indicator",
      () {
        const expectedName = 'warning';
        const expectedIndicator = '!';

        expect(warningConclusion.name, equals(expectedName));
        expect(warningConclusion.indicator, equals(expectedIndicator));
      },
    );
  });
}
