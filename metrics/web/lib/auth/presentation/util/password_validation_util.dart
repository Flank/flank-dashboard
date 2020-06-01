import 'package:metrics/auth/presentation/model/password_validation_error_message.dart';
import 'package:metrics_core/metrics_core.dart';

class PasswordValidationUtil {
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
