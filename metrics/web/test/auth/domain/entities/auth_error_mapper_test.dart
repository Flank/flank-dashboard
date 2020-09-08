import 'package:metrics/auth/domain/entities/auth_error_code.dart';
import 'package:metrics/auth/domain/entities/auth_error_mapper.dart';
import 'package:metrics/auth/presentation/strings/firebase_auth_error_codes.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
void main() {
  group("AuthErrorMapper", () {
    test(
      "returns the user not found error code to the given error string is the user not found error string",
      () {
        final errorCode = AuthErrorMapper.mapErrorStringToErrorCode(
          errorCode: FirebaseAuthErrorCodes.userNotFound,
        );

        expect(errorCode, equals(AuthErrorCode.userNotFound));
      },
    );

    test(
      "returns the invalid email error code to the given error string is the invalid email error string",
      () {
        final errorCode = AuthErrorMapper.mapErrorStringToErrorCode(
          errorCode: FirebaseAuthErrorCodes.invalidEmail,
        );

        expect(errorCode, equals(AuthErrorCode.invalidEmail));
      },
    );

    test(
      "returns the wrong password error code to the given error string is the wrong password error string",
      () {
        final errorCode = AuthErrorMapper.mapErrorStringToErrorCode(
          errorCode: FirebaseAuthErrorCodes.wrongPassword,
        );

        expect(errorCode, equals(AuthErrorCode.wrongPassword));
      },
    );

    test(
      "returns the user disabled error code to the given error string is the user disabled error string",
      () {
        final errorCode = AuthErrorMapper.mapErrorStringToErrorCode(
          errorCode: FirebaseAuthErrorCodes.userDisabled,
        );

        expect(errorCode, equals(AuthErrorCode.userDisabled));
      },
    );

    test(
      "returns the too many requests error code to the given error string is the too many requests error string",
      () {
        final errorCode = AuthErrorMapper.mapErrorStringToErrorCode(
          errorCode: FirebaseAuthErrorCodes.tooManyRequests,
        );

        expect(errorCode, equals(AuthErrorCode.tooManyRequests));
      },
    );

    test(
      "returns the unknown error code to the given error code string that does not correspond to any error code",
      () {
        final actualErrorCode = AuthErrorMapper.mapErrorStringToErrorCode(
          errorCode: "unknown error",
        );

        expect(actualErrorCode, equals(AuthErrorCode.unknown));
      },
    );
  });
}
