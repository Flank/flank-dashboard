import 'package:metrics/auth/domain/entities/password_validation_error_code.dart';
import 'package:metrics/auth/domain/value_objects/password_value_object.dart';
import 'package:metrics/auth/presentation/model/password_validation_error_message.dart';
import 'package:metrics/auth/presentation/strings/auth_strings.dart';
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
          equals(AuthStrings.requiredPasswordErrorMessage),
        );
      },
    );

    test(
      ".message maps tooShortPassword error code to password must be at least 6 characters long error message",
      () {
        const errorMessage = PasswordValidationErrorMessage(
          PasswordValidationErrorCode.tooShortPassword,
        );

        expect(
          errorMessage.message,
          equals(
            AuthStrings.getPasswordMinLengthErrorMessage(
                PasswordValueObject.minPasswordLength),
          ),
        );
      },
    );

    test(".message returns null if the given code is null", () {
      const errorMessage = PasswordValidationErrorMessage(null);

      expect(errorMessage.message, isNull);
    });
  });
}
