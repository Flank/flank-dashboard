import 'package:metrics/auth/domain/entities/auth_error_code.dart';
import 'package:metrics/auth/domain/entities/firebase_auth_error_code.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("FirebaseAuthErrorCode", () {
    test(
      "creates an instance with the given error string",
      () {
        const errorCode = 'error';
        final firebaseAuthErrorCode = FirebaseAuthErrorCode(errorCode);

        expect(firebaseAuthErrorCode.errorCode, equals(errorCode));
      },
    );

    test(
      ".toAuthErrorCode() returns the user not found auth error code to the given error string is the user not found Firebase auth error code string",
      () {
        final firebaseAuthErrorCode =
            FirebaseAuthErrorCode('auth/user-not-found');
        final authErrorCode = firebaseAuthErrorCode.toAuthErrorCode();

        expect(authErrorCode, equals(AuthErrorCode.userNotFound));
      },
    );

    test(
      ".toAuthErrorCode() returns the wrong password auth error code to the given error string is the wrong password Firebase auth error code string",
      () {
        final firebaseAuthErrorCode =
            FirebaseAuthErrorCode('auth/wrong-password');
        final authErrorCode = firebaseAuthErrorCode.toAuthErrorCode();

        expect(authErrorCode, equals(AuthErrorCode.wrongPassword));
      },
    );

    test(
      ".toAuthErrorCode returns the invalid email auth error code to the given error string is the invalid email Firebase auth error code string",
      () {
        final firebaseAuthErrorCode =
            FirebaseAuthErrorCode('auth/invalid-email');
        final authErrorCode = firebaseAuthErrorCode.toAuthErrorCode();

        expect(authErrorCode, equals(AuthErrorCode.invalidEmail));
      },
    );

    test(
      ".toAuthErrorCode() returns the user disabled auth error code to the given error string is the user disabled Firebase auth error code string",
      () {
        final firebaseAuthErrorCode =
            FirebaseAuthErrorCode('auth/user-disabled');
        final authErrorCode = firebaseAuthErrorCode.toAuthErrorCode();

        expect(authErrorCode, equals(AuthErrorCode.userDisabled));
      },
    );

    test(
      ".toAuthErrorCode() returns the too many requests error code to the given error string is the too man requests Firebase auth error code string",
      () {
        final firebaseAuthErrorCode =
            FirebaseAuthErrorCode('auth/too-many-requests');
        final authErrorCode = firebaseAuthErrorCode.toAuthErrorCode();

        expect(authErrorCode, equals(AuthErrorCode.tooManyRequests));
      },
    );

    test(
      ".toAuthErrorCode() returns the unknown error code if there is no corresponding authentication error code for the given Firebase auth error code string",
      () {
        final firebaseAuthErrorCode =
            FirebaseAuthErrorCode('unknown error string');
        final authErrorCode = firebaseAuthErrorCode.toAuthErrorCode();

        expect(authErrorCode, equals(AuthErrorCode.unknown));
      },
    );
  });
}
