import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/auth/domain/entities/email_validation_result.dart';

void main() {
  group("EmailValidationResult", () {
    const email = 'email';
    const isValid = false;

    test("successfully creates with the given required parameters", () {
      expect(
        () => EmailValidationResult(email: email, isValid: isValid),
        returnsNormally,
      );
    });

    test("throws an ArgumentError when created with null email", () {
      expect(
        () => EmailValidationResult(email: null, isValid: isValid),
        throwsArgumentError,
      );
    });

    test(
      "throws an ArgumentError when created with null is valid parameter",
      () {
        expect(
          () => EmailValidationResult(email: email, isValid: null),
          throwsArgumentError,
        );
      },
    );
  });
}
