// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/config.dart';
import 'package:ci_integration/integration/interface/base/config/model/config_field_validation_result.dart';

/// A class that represents a validation result for a specific [Config] file.
abstract class ConfigValidationResult<T extends Config> {
  /// An auth validation result of a specific [Config].
  final ConfigFieldValidationResult authValidationResult;

  /// Creates a new instance of the [ConfigValidationResult] with the given
  /// [authValidationResult].
  const ConfigValidationResult(
    this.authValidationResult,
  );

  @override
  String toString();
}
