import 'package:metrics/features/auth/domain/entities/auth_error_code.dart';
import 'package:metrics/features/auth/domain/entities/authentication_exception.dart';
import 'package:test/test.dart';

void main() {
  group("AuthenticationException", () {
    test(
      "constructor creates the instance with unknown error code when the null is passed",
      () {
        const authException = AuthenticationException(code: null);

        expect(authException.code, AuthErrorCode.unknown);
      },
    );
  });
}
