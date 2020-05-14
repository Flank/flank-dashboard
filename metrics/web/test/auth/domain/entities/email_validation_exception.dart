import 'package:metrics/auth/domain/entities/email_validation_exception.dart';
import 'package:test/test.dart';

void main() {
  group("EmailValidationException", () {
    test("throws an ArgumentError if the given code is null", () {
      expect(() => EmailValidationException(null), throwsArgumentError);
    });
  });
}
