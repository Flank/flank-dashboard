import 'package:metrics/features/auth/domain/entities/authentication_exception.dart';
import 'package:test/test.dart';

void main() {
  group("AuthenticationException", () {
    test("can't be created when the code is null", () {
      expect(() => AuthenticationException(code: null), throwsArgumentError);
    });
  });
}
