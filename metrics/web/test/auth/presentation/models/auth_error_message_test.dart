// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/auth/domain/entities/auth_error_code.dart';
import 'package:metrics/auth/presentation/models/auth_error_message.dart';
import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:test/test.dart';

void main() {
  group("AuthErrorMessage", () {
    test(
      "maps the unknown error code to unknown error message",
      () {
        const errorMessage = AuthErrorMessage(AuthErrorCode.unknown);

        expect(errorMessage.message, AuthStrings.unknownErrorMessage);
      },
    );

    test(
      "maps the 'wrong password' error code to the 'wrong password' error message",
      () {
        const errorMessage = AuthErrorMessage(AuthErrorCode.wrongPassword);

        expect(errorMessage.message, AuthStrings.wrongPasswordErrorMessage);
      },
    );

    test(
      "maps the 'invalid email' error code to the 'invalid email' error message",
      () {
        const errorMessage = AuthErrorMessage(AuthErrorCode.invalidEmail);

        expect(errorMessage.message, AuthStrings.invalidEmailErrorMessage);
      },
    );

    test(
      "maps the 'too many requests' error code to the 'too many requests' error message",
      () {
        const errorMessage = AuthErrorMessage(AuthErrorCode.tooManyRequests);

        expect(errorMessage.message, AuthStrings.tooManyRequestsErrorMessage);
      },
    );

    test(
      "maps the 'user disabled' error code to the 'user disabled' error message",
      () {
        const errorMessage = AuthErrorMessage(AuthErrorCode.userDisabled);

        expect(errorMessage.message, AuthStrings.userDisabledErrorMessage);
      },
    );

    test(
      "maps the 'user not found' error code to the 'user not found' error message",
      () {
        const errorMessage = AuthErrorMessage(AuthErrorCode.userNotFound);

        expect(errorMessage.message, AuthStrings.userNotFoundErrorMessage);
      },
    );

    test(
      "maps the 'google sign in error' error code to the 'google sign in error occurred' error message",
      () {
        const errorMessage = AuthErrorMessage(AuthErrorCode.googleSignInError);

        expect(errorMessage.message, AuthStrings.googleSignInErrorOccurred);
      },
    );

    test(
      "maps the 'not allowed email domain' error code to the 'not allowed email domain' error message",
      () {
        const errorMessage = AuthErrorMessage(
          AuthErrorCode.notAllowedEmailDomain,
        );

        expect(
          errorMessage.message,
          AuthStrings.notAllowedEmailDomainErrorMessage,
        );
      },
    );

    test(
      "returns null if the given error code is null",
      () {
        const errorMessage = AuthErrorMessage(null);

        expect(errorMessage.message, isNull);
      },
    );
  });
}
