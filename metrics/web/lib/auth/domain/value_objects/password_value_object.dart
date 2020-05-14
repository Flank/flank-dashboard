import 'package:metrics/auth/domain/entities/password_validation_error_code.dart';
import 'package:metrics/auth/domain/entities/password_validation_exception.dart';
import 'package:metrics_core/metrics_core.dart';

/// A [ValueObject] represents a password.
class PasswordValueObject implements ValueObject<String> {
  static const int minPasswordLength = 6;

  @override
  final String value;

  /// Creates the [PasswordValueObject].
  ///
  /// If [value] is null or value length is less than [minPasswordLength] characters
  /// long throws a [PasswordValidationException].
  PasswordValueObject(this.value) {
    if (value == null || value.isEmpty) {
      throw PasswordValidationException(PasswordValidationErrorCode.isNull);
    }

    if (value.length < minPasswordLength) {
      throw PasswordValidationException(
        PasswordValidationErrorCode.tooShortPassword,
      );
    }
  }
}
