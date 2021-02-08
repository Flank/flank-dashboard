// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("Email", () {
    test(
      "throws an EmailValidationException with isNull error code when the value is null",
      () {
        final emailIsNullException = EmailValidationException(
          EmailValidationErrorCode.isNull,
        );

        expect(
          () => Email(null),
          throwsA(equals(emailIsNullException)),
        );
      },
    );

    test(
      "throws an EmailValidationException with invalidEmailFormat error code when the value is not a valid email",
      () {
        final invalidFormatException = EmailValidationException(
          EmailValidationErrorCode.invalidEmailFormat,
        );

        expect(
          () => Email('not an email'),
          throwsA(equals(invalidFormatException)),
        );
      },
    );

    test(
      "creates an instance with the given value",
      () {
        const validEmail = "valid@mail.com";
        final email = Email(validEmail);

        expect(email.value, equals(validEmail));
      },
    );

    test(
      "equals to another Email if their values are equal",
      () {
        const email = 'email@mail.mail';
        final firstEmail = Email(email);
        final secondEmail = Email(email);

        expect(firstEmail, equals(secondEmail));
      },
    );
  });
}
