// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/config.dart';

/// Represents a conclusion of the [Config] field validation.
enum ConfigFieldValidationConclusion {
  /// Represents a conclusion that the field is valid.
  valid,

  /// Represents a conclusion that the field is invalid.
  invalid,

  /// Represents that the conclusion is unknown.
  unknown,
}
