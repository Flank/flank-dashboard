// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:collection';

import 'package:ci_integration/integration/interface/base/config/model/config.dart';
import 'package:ci_integration/integration/interface/base/config/model/config_field.dart';
import 'package:ci_integration/integration/validation/model/field_validation_result.dart';
import 'package:equatable/equatable.dart';

/// A class that represents a validation result for a single [Config].
class ValidationResult extends Equatable {
  /// A [Map] that holds the validation result values for each [Config] field.
  final UnmodifiableMapView<ConfigField, FieldValidationResult> results;

  @override
  List<Object> get props => [results];

  /// Creates a new instance of the [ValidationResult] with the given [results].
  ///
  /// Throws an [ArgumentError] if the given [results] is `null`.
  ValidationResult(
    Map<ConfigField, FieldValidationResult> results,
  ) : results = UnmodifiableMapView(results) {
    ArgumentError.checkNotNull(results);
  }
}
