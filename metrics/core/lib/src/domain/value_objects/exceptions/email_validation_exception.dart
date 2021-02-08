// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics_core/src/domain/value_objects/exceptions/validation_exception.dart';
import 'package:metrics_core/src/domain/value_objects/exceptions/email_validation_error_code.dart';

/// Represents the email validation exception.
class EmailValidationException
    extends ValidationException<EmailValidationErrorCode> {
  @override
  final EmailValidationErrorCode code;

  /// Creates the [EmailValidationException] with the given [code].
  ///
  /// [code] is the code of this error that specifies the concrete reason for the exception occurrence.
  /// Throws an [ArgumentError] if the [code] is null.
  EmailValidationException(this.code);
}
