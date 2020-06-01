import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics/auth/presentation/util/email_validation_util.dart';
import 'package:test/test.dart';

void main() {
  group("ValidationUtil", () {
    test(
      ".validateEmail() returns the email required error message if the given email is null",
      () {
        final validationResult = EmailValidationUtil.validateEmail(null);

        expect(validationResult, equals(AuthStrings.emailRequiredErrorMessage));
      },
    );

    test(
      ".validateEmail() returns the invalid email error message if the given email is malformed",
      () {
        final validationResult = EmailValidationUtil.validateEmail('not valid');

        expect(validationResult, equals(AuthStrings.invalidEmailErrorMessage));
      },
    );

    test(
      ".validateEmail() returns null if the given email is valid",
      () {
        final validationResult =
            EmailValidationUtil.validateEmail('email@mail.mail');

        expect(validationResult, isNull);
      },
    );
  });
}
