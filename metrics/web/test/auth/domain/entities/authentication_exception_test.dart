import 'package:metrics/auth/domain/entities/auth_error_code.dart';
import 'package:metrics/auth/domain/entities/authentication_exception.dart';
import 'package:test/test.dart';

// https://github.com/platform-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

void main() {
  group("AuthenticationException", () {
    test(
      "constructor creates the instance with unknown error code when the null is passed",
      () {
        final authException = AuthenticationException(code: null);

        expect(authException.code, AuthErrorCode.unknown);
      },
    );
  });
}
