import 'package:metrics/auth/data/converter/firebase_auth_error_code_converter.dart';
import 'package:metrics/auth/data/model/firebase_auth_error_code.dart';
import 'package:metrics/auth/domain/entities/auth_error_code.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("FirebaseAuthErrorCodeConverter", () {
    final converter =
        FirebaseAuthErrorCodeConverter.convertErrorStringToErrorCode;

    test(
      ".convertErrorStringToErrorCode() returns the user not found auth error code to the given error string is the user not found Firebase auth error code string",
      () {
        final authErrorCode = converter(FirebaseAuthErrorCode.userNotFound);

        expect(authErrorCode, equals(AuthErrorCode.userNotFound));
      },
    );

    test(
      ".convertErrorStringToErrorCode() returns the wrong password auth error code to the given error string is the wrong password Firebase auth error code string",
      () {
        final authErrorCode = converter(FirebaseAuthErrorCode.wrongPassword);

        expect(authErrorCode, equals(AuthErrorCode.wrongPassword));
      },
    );

    test(
      ".convertErrorStringToErrorCode() returns the invalid email auth error code to the given error string is the invalid email Firebase auth error code string",
      () {
        final authErrorCode = converter(FirebaseAuthErrorCode.invalidEmail);

        expect(authErrorCode, equals(AuthErrorCode.invalidEmail));
      },
    );

    test(
      ".convertErrorStringToErrorCode() returns the user disabled auth error code to the given error string is the user disabled Firebase auth error code string",
      () {
        final authErrorCode = converter(FirebaseAuthErrorCode.userDisabled);

        expect(authErrorCode, equals(AuthErrorCode.userDisabled));
      },
    );

    test(
      ".convertErrorStringToErrorCode() returns the too many requests error code to the given error string is the too man requests Firebase auth error code string",
      () {
        final authErrorCode = converter(FirebaseAuthErrorCode.tooManyRequests);

        expect(authErrorCode, equals(AuthErrorCode.tooManyRequests));
      },
    );

    test(
      ".convertErrorStringToErrorCode() returns the unknown error code if there is no corresponding authentication error code for the given Firebase auth error code string",
      () {
        final authErrorCode = converter("unknown error");

        expect(authErrorCode, equals(AuthErrorCode.unknown));
      },
    );

    test(
      ".convertErrorStringToErrorCode() returns the unknown error code if the given Firebase auth error code string is null",
      () {
        final authErrorCode = converter(null);

        expect(authErrorCode, equals(AuthErrorCode.unknown));
      },
    );
  });
}
