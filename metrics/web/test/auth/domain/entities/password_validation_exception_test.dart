import 'package:metrics/auth/domain/entities/password_validation_exception.dart';
import 'package:test/test.dart';

void main() {
  group("PasswordValidationException", () {
    test("throws an ArgumentError if the given code is null", () {
      expect(() => PasswordValidationException(null), throwsArgumentError);
    });
  });
}
