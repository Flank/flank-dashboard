// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/field_validation_result.dart';
import 'package:ci_integration/integration/interface/base/config/model/validation_result.dart';
import 'package:ci_integration/integration/interface/source/config/model/source_config.dart';

/// A class that represents a validation result for a [SourceConfig].
abstract class SourceValidationResult extends ValidationResult {
  /// A [FieldValidationResult] of the source project id validation.
  FieldValidationResult get sourceProjectIdValidationResult;
}
