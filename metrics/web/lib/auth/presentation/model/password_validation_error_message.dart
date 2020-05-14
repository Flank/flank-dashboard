import 'package:metrics/auth/domain/entities/password_validation_error_code.dart';
import 'package:metrics/auth/domain/value_objects/password_value_object.dart';
import 'package:metrics/auth/presentation/strings/auth_strings.dart';

/// A class that provides the password validation error description based on [PasswordValidationErrorMessage].
class PasswordValidationErrorMessage {
  final PasswordValidationErrorCode _code;

  /// Creates the [PasswordValidationErrorMessage] from the given [PasswordValidationErrorCode].
  const PasswordValidationErrorMessage(this._code);

  /// Provides the password validation error message based on the [PasswordValidationErrorCode].
  String get message {
    switch (_code) {
      case PasswordValidationErrorCode.isNull:
        return AuthStrings.requiredPasswordErrorMessage;
      case PasswordValidationErrorCode.tooShortPassword:
        return AuthStrings.getPasswordMinLengthErrorMessage(
          PasswordValueObject.minPasswordLength,
        );
      default:
        return null;
    }
  }
}
