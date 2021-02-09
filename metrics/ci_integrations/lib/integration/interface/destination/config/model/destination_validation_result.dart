// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/field_validation_result.dart';
import 'package:ci_integration/integration/interface/base/config/model/validation_result.dart';
import 'package:ci_integration/integration/interface/destination/config/model/destination_config.dart';

/// A class that represents a validation result for a [DestinationConfig].
abstract class DestinationValidationResult extends ValidationResult {
  /// A [FieldValidationResult] of the destination project id validation.
  FieldValidationResult get destinationProjectIdValidationResult;
}
