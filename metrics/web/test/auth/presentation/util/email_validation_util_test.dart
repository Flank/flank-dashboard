import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics/auth/presentation/util/email_validation_util.dart';
import 'package:test/test.dart';

void main() {
  group("EmailValidationUtil", () {
    test(
      ".validate() returns the email required error message if the given email is null",
      () {
        final validationResult = EmailValidationUtil.validate(null);

        expect(validationResult, equals(AuthStrings.emailRequiredErrorMessage));
      },
    );

    test(
      ".validate() returns the invalid email error message if the given email is malformed",
      () {
        final validationResult = EmailValidationUtil.validate('not valid');

        expect(validationResult, equals(AuthStrings.invalidEmailErrorMessage));
      },
    );

    test(
      ".validate() returns null if the given email is valid",
      () {
        final validationResult =
            EmailValidationUtil.validate('email@mail.mail');

        expect(validationResult, isNull);
      },
    );
  });
}
