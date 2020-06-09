import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics/auth/presentation/validators/email_validator.dart';
import 'package:test/test.dart';

void main() {
  group("EmailValidator", () {
    test(
      ".validate() returns the email required error message if the given email is null",
      () {
        final validationResult = EmailValidator.validate(null);

        expect(validationResult, equals(AuthStrings.emailRequiredErrorMessage));
      },
    );

    test(
      ".validate() returns the invalid email error message if the given email is malformed",
      () {
        final validationResult = EmailValidator.validate('not valid');

        expect(validationResult, equals(AuthStrings.invalidEmailErrorMessage));
      },
    );

    test(
      ".validate() returns null if the given email is valid",
      () {
        final validationResult =
            EmailValidator.validate('email@mail.mail');

        expect(validationResult, isNull);
      },
    );
  });
}
