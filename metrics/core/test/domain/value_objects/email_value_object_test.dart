import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("EmailValueObject", () {
    test(
      "throws an EmailValidationException with isNull error code when the value is null",
      () {
        final emailIsNullException = EmailValidationException(
          EmailValidationErrorCode.isNull,
        );

        expect(
          () => EmailValueObject(null),
          throwsA(equals(emailIsNullException)),
        );
      },
    );

    test(
      "throws an EmailValidationException with invalidEmailFormat error code when the value is not a valid email",
      () {
        final invalidFormatException = EmailValidationException(
          EmailValidationErrorCode.invalidEmailFormat,
        );

        expect(
          () => EmailValueObject('not an email'),
          throwsA(equals(invalidFormatException)),
        );
      },
    );

    test(
      "creates an EmailValueObject with the given email as a value if it is valid",
      () {
        const validEmail = "valid@mail.com";
        final email = EmailValueObject(validEmail);

        expect(email.value, equals(validEmail));
      },
    );

    test(
      "equals to another EmailValueObject if their values are equal",
      () {
        const email = 'email@mail.mail';
        final firstEmail = EmailValueObject(email);
        final secondEmail = EmailValueObject(email);

        expect(firstEmail, equals(secondEmail));
      },
    );
  });
}
