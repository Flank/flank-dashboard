// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/builder/validation_result_builder.dart';
import 'package:ci_integration/integration/interface/base/config/model/field_validation_result.dart';
import 'package:ci_integration/integration/interface/source/config/model/source_validation_result.dart';

/// A class that provides an ability to build a [SourceValidationResult].
abstract class SourceValidationResultBuilder<T extends SourceValidationResult>
    extends ValidationResultBuilder<T> {
  /// A [FieldValidationResult] of the source project id validation.
  FieldValidationResult sourceProjectIdValidationResult;

  /// Creates a new instance of the [SourceValidationResultBuilder].
  SourceValidationResultBuilder();
}
