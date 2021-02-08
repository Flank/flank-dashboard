// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("Password", () {
    test(
      "throws a PasswordValidationException with isNull error code when the value is null",
      () {
        final isNullValidationException = PasswordValidationException(
          PasswordValidationErrorCode.isNull,
        );

        expect(
          () => Password(null),
          throwsA(equals(isNullValidationException)),
        );
      },
    );

    test(
      "throws a PasswordValidationException with tooShortPassword error code when the value is too short",
      () {
        final isNullValidationException = PasswordValidationException(
          PasswordValidationErrorCode.tooShortPassword,
        );

        expect(
          () => Password('pass'),
          throwsA(equals(isNullValidationException)),
        );
      },
    );

    test(
      "creates an instance with the given value",
      () {
        const password = 'password';
        final passwordValueObject = Password(password);

        expect(passwordValueObject.value, equals(password));
      },
    );

    test(
      "equals to another Password if their values are equal",
      () {
        const password = 'password';
        final firstPassword = Password(password);
        final secondPassword = Password(password);

        expect(firstPassword, equals(secondPassword));
      },
    );
  });
}
