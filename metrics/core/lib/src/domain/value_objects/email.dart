import 'package:email_validator/email_validator.dart';
import 'package:metrics_core/metrics_core.dart';

/// A [ValueObject] that represents an email value.
class Email extends ValueObject<String> {
  @override
  final String value;

  /// Creates the [Email] with the given [value].
  ///
  /// If the [value] is null or is not a valid email throws an [EmailValidationException].
  Email(this.value) {
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
