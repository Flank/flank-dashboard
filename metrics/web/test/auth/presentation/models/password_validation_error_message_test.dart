import 'package:metrics/auth/presentation/models/password_validation_error_message.dart';
import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("PasswordValidationErrorMessage", () {
    test(
      ".message maps isNull error code to required password message",
      () {
        const errorMessage = PasswordValidationErrorMessage(
          PasswordValidationErrorCode.isNull,
        );

        expect(
          errorMessage.message,
          equals(AuthStrings.passwordRequiredErrorMessage),
        );
      },
    );

    test(
      ".message maps tooShortPassword error code to password must be at least minPasswordLength characters long error message",
      () {
        const errorMessage = PasswordValidationErrorMessage(
          PasswordValidationErrorCode.tooShortPassword,
        );
        final expectedMessage = AuthStrings.getPasswordMinLengthErrorMessage(
          Password.minPasswordLength,
        );

        expect(errorMessage.message, equals(expectedMessage));
      },
    );

    test(".message returns null if the given code is null", () {
      const errorMessage = PasswordValidationErrorMessage(null);

      expect(errorMessage.message, isNull);
    });
  });
}
