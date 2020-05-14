import 'package:metrics/auth/domain/entities/password_validation_error_code.dart';
import 'package:metrics/auth/domain/entities/password_validation_exception.dart';
import 'package:metrics/auth/domain/value_objects/password_value_object.dart';
import 'package:test/test.dart';

void main() {
  group("PasswordValueObject", () {
    test(
      "throws a PasswordValidationException with isNull error code when the value is null",
      () {
        final isNullValidationException = PasswordValidationException(
          PasswordValidationErrorCode.isNull,
        );

        expect(
          () => PasswordValueObject(null),
          throwsA(equals(isNullValidationException)),
        );
      },
    );

    test(
      "throws a PasswordValidationException with tooShortPassword error code when the value is too short",
      () {
        final isNullValidationException = PasswordValidationException(
          PasswordValidationErrorCode.tooShortPassword,
        );

        expect(
          () => PasswordValueObject('pass'),
          throwsA(equals(isNullValidationException)),
        );
      },
    );

    test(
      "creates a PasswordValueObject with the given password as a value is it is valid",
      () {
        const password = 'password';
        final passwordValueObject = PasswordValueObject(password);

        expect(passwordValueObject.value, equals(password));
      },
    );
  });
}
