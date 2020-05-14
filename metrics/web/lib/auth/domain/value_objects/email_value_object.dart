import 'package:email_validator/email_validator.dart';
import 'package:metrics/auth/domain/entities/email_validation_error_code.dart';
import 'package:metrics/auth/domain/entities/email_validation_exception.dart';
import 'package:metrics_core/metrics_core.dart';

/// A [ValueObject] represents an email.
class EmailValueObject implements ValueObject<String> {
  @override
  final String value;

  /// Creates the [EmailValueObject] with the given [value].
  ///
  /// If the [value] is null or is not a valid email throws an [EmailValidationException].
  EmailValueObject(this.value) {
    if (value == null || value.isEmpty) {
      throw EmailValidationException(EmailValidationErrorCode.isNull);
    }

    if (!EmailValidator.validate(value)) {
      throw EmailValidationException(
        EmailValidationErrorCode.invalidEmailFormat,
      );
    }
  }
}
