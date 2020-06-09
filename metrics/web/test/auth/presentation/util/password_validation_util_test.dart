import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics/auth/presentation/util/password_validation_util.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("PasswordValidationUtil", () {
    test(
      ".validate() returns the password required error message if the password is null",
          () {
        final validationResult = PasswordValidationUtil.validate(null);

        expect(
            validationResult, equals(AuthStrings.passwordRequiredErrorMessage));
      },
    );

    test(
      ".validate() returns the password too short error message if the password is less than 6 characters long",
          () {
        final validationResult = PasswordValidationUtil.validate('pass');

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
      ".validate() returns null if the given password is valid",
          () {
        final validationResult = PasswordValidationUtil.validate('password');

        expect(validationResult, isNull);
      },
    );
  });
}
