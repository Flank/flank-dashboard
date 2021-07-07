// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/config.dart';
import 'package:metrics_core/metrics_core.dart';

/// Represents a validation conclusion for a specific [Config] field.
class ConfigFieldValidationConclusion {
  /// Represents a conclusion that the field is valid.
  static const valid = ValidationConclusion(name: 'valid');

  /// Represents a conclusion that the field is invalid.
  static const invalid = ValidationConclusion(name: 'invalid');

  /// Represents that the conclusion is unknown.
  static const unknown = ValidationConclusion(name: 'unknown');
}
