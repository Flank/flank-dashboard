import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics/auth/presentation/util/auth_validation_util.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("ValidationUtil", () {
    test(
      ".validateEmail() returns the email required error message if the given email is null",
      () {
        final validationResult = AuthValidationUtil.validateEmail(null);

        expect(validationResult, equals(AuthStrings.emailRequiredErrorMessage));
      },
    );

    test(
      ".validateEmail() returns the invalid email error message if the given email is malformed",
      () {
        final validationResult = AuthValidationUtil.validateEmail('not valid');

        expect(validationResult, equals(AuthStrings.invalidEmailErrorMessage));
      },
    );

    test(
      ".validateEmail() returns null if the given email is valid",
      () {
        final validationResult =
            AuthValidationUtil.validateEmail('email@mail.mail');

        expect(validationResult, isNull);
      },
    );

    test(
      ".validatePassword() returns the password required error message if the password is null",
      () {
        final validationResult = AuthValidationUtil.validatePassword(null);

        expect(
            validationResult, equals(AuthStrings.passwordRequiredErrorMessage));
      },
    );

    test(
      ".validatePassword() returns the password too short error message if the password is less than 6 characters long",
      () {
        final validationResult = AuthValidationUtil.validatePassword('pass');

        expect(
          validationResult,
          equals(
            AuthStrings.getPasswordMinLengthErrorMessage(
              Password.minPasswordLength,
            ),
          ),
        );
      },
    );

    test(
      ".validatePassword() returns null if the given password is valid",
      () {
        final validationResult = AuthValidationUtil.validatePassword('password');

        expect(validationResult, isNull);
      },
    );
  });
}
