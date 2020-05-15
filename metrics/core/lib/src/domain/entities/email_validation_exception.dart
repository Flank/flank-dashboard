import 'package:metrics_core/src/domain/entities/email_validation_error_code.dart';
import 'package:metrics_core/src/domain/entities/validation_exception.dart';

/// A [ValidationException] thrown once the email validation failed.
///
/// Provides an [EmailValidationErrorCode].
class EmailValidationException
    extends ValidationException<EmailValidationErrorCode> {
  @override
  final EmailValidationErrorCode code;

  /// Creates the [EmailValidationException] with the given [code].
  EmailValidationException(this.code);
}
