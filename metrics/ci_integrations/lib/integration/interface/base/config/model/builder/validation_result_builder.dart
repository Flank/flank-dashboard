// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/field_validation_result.dart';
import 'package:ci_integration/integration/interface/base/config/model/validation_result.dart';

///
abstract class ValidationResultBuilder<T extends ValidationResult> {
  /// An auth validation result of a specific [Config].
  final FieldValidationResult authValidationResult;

  ///
  final String interruptReason;

  /// Creates a new instance of the [ValidationResultBuilder] with the
  /// given [authValidationResult] and [interruptReason].
  const ValidationResultBuilder({
    this.authValidationResult,
    this.interruptReason,
  });

  ///
  T build();

  ///
  void setAuthResult(FieldValidationResult authResult);

  ///
  void setInterruptReason(String reason);
}
