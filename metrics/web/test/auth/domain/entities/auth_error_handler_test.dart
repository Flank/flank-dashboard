import 'package:metrics/auth/domain/entities/auth_error_code.dart';
import 'package:metrics/auth/domain/entities/auth_error_handler.dart';
import 'package:metrics/auth/presentation/strings/auth_error_code_strings.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
void main() {
  group("AuthErrorHandler", () {
    const expectedErrorsMap = <String, AuthErrorCode>{
      AuthErrorCodeStrings.userNotFound: AuthErrorCode.userNotFound,
      AuthErrorCodeStrings.invalidEmail: AuthErrorCode.invalidEmail,
      AuthErrorCodeStrings.wrongPassword: AuthErrorCode.wrongPassword,
      AuthErrorCodeStrings.userDisabled: AuthErrorCode.userDisabled,
      AuthErrorCodeStrings.tooManyRequests: AuthErrorCode.tooManyRequests,
    };

    test(
      "returns the corresponding error code to the given error code string",
      () {
        expectedErrorsMap.forEach(
          (errorCodeString, errorCode) {
            final actualErrorCode = AuthErrorHandler.handleError(
              errorCode: errorCodeString,
            );

            expect(actualErrorCode, equals(errorCode));
          },
        );
      },
    );

    test(
      "returns the unknown error code to the given error code string that does not correspond to any error code",
      () {
        final actualErrorCode = AuthErrorHandler.handleError(
          errorCode:
              "an unexpected and unknown error message we couldn't expect",
        );

        expect(actualErrorCode, equals(AuthErrorCode.unknown));
      },
    );
  });
}
