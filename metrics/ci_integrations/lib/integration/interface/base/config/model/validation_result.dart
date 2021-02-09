// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/config.dart';
import 'package:ci_integration/integration/interface/base/config/model/field_validation_result.dart';

/// A class that represents a validation result for a [Config].
abstract class ValidationResult {
  /// A [FieldValidationResult] of the authorization validation.
  FieldValidationResult get authValidationResult;
}
