// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/field_validation_result.dart';
import 'package:ci_integration/integration/interface/base/config/model/validation_result.dart';

/// A class that provides an ability to build a [ValidationResult].
abstract class ValidationResultBuilder<T extends ValidationResult> {
  /// A [FieldValidationResult] of the authorization validation.
  FieldValidationResult authValidationResult;

  /// A [String] representing a validation interruption reason.
  String interruptReason;

  /// Creates a new instance of the [ValidationResultBuilder].
  ValidationResultBuilder();

  /// Builds a [ValidationResult] using provided [FieldValidationResult]s.
  T build();
}
