import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics/auth/presentation/util/validation_util.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("ValidationUtil", () {
    test(
      ".validateEmail() returns an email required error message id the given email is null",
      () {
        final validationResult = ValidationUtil.validateEmail(null);

        expect(validationResult, equals(AuthStrings.emailRequiredErrorMessage));
      },
    );

    test(
      ".validateEmail() returns an invalid email error message id the given email is malformed",
      () {
        final validationResult = ValidationUtil.validateEmail('not valid');

        expect(validationResult, equals(AuthStrings.invalidEmailErrorMessage));
      },
    );

    test(
      ".validateEmail() returns null if the given email is valid",
      () {
        final validationResult =
            ValidationUtil.validateEmail('email@mail.mail');

        expect(validationResult, isNull);
      },
    );

    test(
      ".validatePassword() returns password required error message is the password is null",
      () {
        final validationResult = ValidationUtil.validatePassword(null);

        expect(
            validationResult, equals(AuthStrings.passwordRequiredErrorMessage));
      },
    );

    test(
      ".validatePassword() returns password too short error message is the password is less that 6 characters long",
      () {
        final validationResult = ValidationUtil.validatePassword('pass');

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
        final validationResult = ValidationUtil.validatePassword('password');

        expect(validationResult, isNull);
      },
    );
  });
}
