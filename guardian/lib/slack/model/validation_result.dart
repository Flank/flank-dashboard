// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

/// A class containing a result of validation.
class ValidationResult {
  /// Used to indicate that validation is failed.
  final bool _isValid;

  /// Contains message with a result of validation.
  /// If validation is failed, contains error message with details.
  final String message;

  bool get isValid => _isValid;

  bool get isInvalid => !_isValid;

  ValidationResult._(this._isValid, this.message);

  /// Creates an instance representing successful validation.
  ValidationResult.valid([String message]) : this._(true, message);

  /// Creates an instance representing failed validation.
  ValidationResult.invalid([String message]) : this._(false, message);

  /// Combines this validation result with [other] into new one in a
  /// conjunction way.
  ///
  /// In other words, new validation result is valid if and only if both
  /// current and [other] validation results are valid.
  ValidationResult combine(ValidationResult other) {
    if (other == null) return this;
    if (isValid) {
      return other.isValid
          ? ValidationResult.valid(message)
          : ValidationResult.invalid(other.message);
    } else {
      return this;
    }
  }

  @override
  String toString() {
    return '$runtimeType {isValid: $_isValid, message: $message}';
  }
}
