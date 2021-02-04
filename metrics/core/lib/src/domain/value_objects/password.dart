// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics_core/metrics_core.dart';

/// A [ValueObject] represents a password.
class Password extends ValueObject<String> {
  /// Minimum length of the password.
  static const int minPasswordLength = 6;

  @override
  final String value;

  /// Creates the [Password] with the given [value].
  ///
  /// If [value] is null or value length is less than [minPasswordLength] characters
  /// long throws a [PasswordValidationException].
  Password(this.value) {
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
