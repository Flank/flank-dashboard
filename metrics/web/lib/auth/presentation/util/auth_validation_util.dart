import 'package:metrics/auth/presentation/model/email_validation_error_message.dart';
import 'package:metrics/auth/presentation/model/password_validation_error_message.dart';
import 'package:metrics_core/metrics_core.dart';

class AuthValidationUtil {
  /// Validates the given [value] as an email.
  ///
  /// Returns an error message if the [value] is not a valid email,
  /// otherwise returns null.
  static String validateEmail(String value) {
    EmailValidationErrorMessage errorMessage;

    try {
      Email(value);
    } on EmailValidationException catch (exception) {
      errorMessage = EmailValidationErrorMessage(
        exception.code,
      );
    }

    return errorMessage?.message;
  }

  /// Validates the given [value] as a password.
  ///
  /// Returns an error message if the [value] is not a valid password,
  /// otherwise returns null.
  static String validatePassword(String value) {
    PasswordValidationErrorMessage errorMessage;

    try {
      Password(value);
    } on PasswordValidationException catch (exception) {
      errorMessage = PasswordValidationErrorMessage(
        exception.code,
      );
    }

    return errorMessage?.message;
  }
}
