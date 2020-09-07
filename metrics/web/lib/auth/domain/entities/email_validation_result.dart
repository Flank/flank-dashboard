import 'package:meta/meta.dart';

/// An entity representing the result of the email validation.
@immutable
class EmailValidationResult {
  /// A validated email.
  final String email;

  /// A validation status of the [email].
  final bool isValid;

  /// Creates an instance of the [EmailValidationResult] with the
  /// given [email] and [isValid] status.
  ///
  /// Throws an [ArgumentError] if either the [email] or [isValid] is `null`.
  EmailValidationResult({
    this.email,
    this.isValid,
  }) {
    ArgumentError.checkNotNull(email, 'email');
    ArgumentError.checkNotNull(isValid, 'isValid');
  }
}
