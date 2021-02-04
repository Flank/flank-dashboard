// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:meta/meta.dart';

/// An entity representing the result of the email domain validation.
@immutable
class EmailDomainValidationResult {
  /// A validation status of the email domain.
  final bool isValid;

  /// Creates an instance of the [EmailDomainValidationResult] with the
  /// given [isValid] status.
  ///
  /// Throws an [ArgumentError] if the [isValid] is `null`.
  EmailDomainValidationResult({
    @required this.isValid,
  }) {
    ArgumentError.checkNotNull(isValid, 'isValid');
  }
}
