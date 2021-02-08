// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics/auth/presentation/validators/password_validator.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("PasswordValidator", () {
    test(
      ".validate() returns the 'password required' error message if the password is null",
      () {
        final validationResult = PasswordValidator.validate(null);

        expect(
          validationResult,
          equals(AuthStrings.passwordRequiredErrorMessage),
        );
      },
    );

    test(
      ".validate() returns the 'password too short' error message if the password is less than Password.minPasswordLength",
      () {
        final validationResult = PasswordValidator.validate('pass');
        final expectedMessage = AuthStrings.getPasswordMinLengthErrorMessage(
          Password.minPasswordLength,
        );

        expect(
          validationResult,
          equals(expectedMessage),
        );
      },
    );

    test(
      ".validate() returns null if the given password is valid",
      () {
        final validationResult = PasswordValidator.validate('password');

        expect(validationResult, isNull);
      },
    );
  });
}
