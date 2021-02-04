// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that provides the password validation error description based on [PasswordValidationErrorMessage].
class PasswordValidationErrorMessage {
  /// A [PasswordValidationErrorCode] provides an information
  /// of concrete password validation error.
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
