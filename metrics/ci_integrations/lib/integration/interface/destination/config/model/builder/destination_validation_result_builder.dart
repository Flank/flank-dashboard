// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/builder/validation_result_builder.dart';
import 'package:ci_integration/integration/interface/base/config/model/field_validation_result.dart';
import 'package:ci_integration/integration/interface/destination/config/model/destination_validation_result.dart';

/// A class that provides an ability to build a [DestinationValidationResult].
abstract class DestinationValidationResultBuilder<
    T extends DestinationValidationResult> extends ValidationResultBuilder<T> {
  /// A [FieldValidationResult] of the destination project id validation.
  FieldValidationResult destiantionProjectIdValidationResult;

  /// Creates a new instance of the [DestinationValidationResultBuilder].
  DestinationValidationResultBuilder();
}
