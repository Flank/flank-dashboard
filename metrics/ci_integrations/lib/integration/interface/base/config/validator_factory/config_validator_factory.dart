// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/validator/config_validator.dart';

/// An abstract class that provides a method for creating [ConfigValidator]s.
abstract class ConfigValidatorFactory<T extends ConfigValidator> {
  /// Creates an instance of the [ConfigValidator].
  T create();
}
