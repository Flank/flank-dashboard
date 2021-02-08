// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/auth/presentation/models/email_validation_error_message.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class for validating an email.
class EmailValidator {
  /// Validates the given [value] as an email.
  ///
  /// Returns an error message if the [value] is not a valid email,
  /// otherwise returns null.
  static String validate(String value) {
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
}
