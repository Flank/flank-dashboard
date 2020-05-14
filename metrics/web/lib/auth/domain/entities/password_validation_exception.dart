import 'package:metrics/auth/domain/entities/password_validation_error_code.dart';
import 'package:metrics/common/domain/entities/validation_exception.dart';

/// Represents the password validation exception.
/// A [ValidationException] thrown when the password validation is failed.
///

/// Creates the [PasswordValidationException] with the given [code].
///
/// [code] is the code of this error that specifies the concrete reason for the exception occurrence.
/// Throws an [ArgumentError] if the [code] is null.
class PasswordValidationException
    extends ValidationException<PasswordValidationErrorCode> {
  @override
  final PasswordValidationErrorCode code;

  /// Creates the [PasswordValidationException] with the given [code].
  PasswordValidationException(this.code);
}
