// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/auth/presentation/models/email_validation_error_message.dart';
import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("EmailValidationErrorMessage", () {
    test(
      ".message maps isNull error code to email address is required error message",
      () {
        const errorMessage = EmailValidationErrorMessage(
          EmailValidationErrorCode.isNull,
        );

        expect(errorMessage.message, AuthStrings.emailRequiredErrorMessage);
      },
    );

    test(
      ".message maps invalidEmailFormat error code to invalidEmailError error message",
      () {
        const errorMessage = EmailValidationErrorMessage(
          EmailValidationErrorCode.invalidEmailFormat,
        );

        expect(errorMessage.message, AuthStrings.invalidEmailErrorMessage);
      },
    );

    test(".message returns null if the given code is null", () {
      const errorMessage = EmailValidationErrorMessage(null);

      expect(errorMessage.message, isNull);
    });
  });
}
