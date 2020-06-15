import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that provides the password validation error description based on [PasswordValidationErrorMessage].
class PasswordValidationErrorMessage {
  final PasswordValidationErrorCode _code;

  /// Creates the [PasswordValidationErrorMessage] with the given [PasswordValidationErrorCode].
  const PasswordValidationErrorMessage(this._code);

  /// Provides the password validation error message based on the [PasswordValidationErrorCode].
  String get message {
    switch (_code) {
      case PasswordValidationErrorCode.isNull:
        return AuthStrings.passwordRequiredErrorMessage;
      case PasswordValidationErrorCode.tooShortPassword:
        return AuthStrings.getPasswordMinLengthErrorMessage(
          Password.minPasswordLength,
        );
      default:
        return null;
    }
  }
}
