// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/config.dart';
import 'package:ci_integration/integration/interface/base/config/validation_delegate/validation_delegate.dart';
import 'package:ci_integration/integration/validation/model/validation_result.dart';

/// An abstract class responsible for validating the [Config].
abstract class ConfigValidator<T extends Config> {
  /// A [ValidationDelegate] this validator uses for [Config]'s
  /// specific fields validation.
  ValidationDelegate get validationDelegate;

  /// Validates the given [config].
  Future<ValidationResult> validate(T config);
}
