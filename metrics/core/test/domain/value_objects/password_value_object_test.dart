import 'package:metrics_core/metrics_core.dart';
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

    test(
      "equals to another PasswordValueObject if their values are equal",
      () {
        const password = 'password';
        final firstPassword = PasswordValueObject(password);
        final secondPassword = PasswordValueObject(password);

        expect(firstPassword, equals(secondPassword));
      },
    );
  });
}
