import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics/auth/presentation/validators/password_validator.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("PasswordValidator", () {
    test(
      ".validate() returns the password required error message if the password is null",
          () {
        final validationResult = PasswordValidator.validate(null);

        expect(
            validationResult, equals(AuthStrings.passwordRequiredErrorMessage));
      },
    );

    test(
      ".validate() returns the password too short error message if the password is less than 6 characters long",
          () {
        final validationResult = PasswordValidator.validate('pass');

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
        final validationResult = PasswordValidator.validate('password');

        expect(validationResult, isNull);
      },
    );
  });
}
