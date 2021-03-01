// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/config.dart';
import 'package:ci_integration/integration/interface/base/config/validator/config_validator.dart';
import 'package:ci_integration/integration/validation/model/validation_result.dart';
import 'package:ci_integration/integration/validation/model/validation_result_builder.dart';

/// A stub implementation of the [ConfigValidator].
class ValidatorStub<T extends Config> implements ConfigValidator<T> {
  @override
  final ValidationResultBuilder validationResultBuilder =
      ValidationResultBuilder.forFields([]);

  @override
  Future<ValidationResult> validate(T config) {
    return Future.value(
      ValidationResult(const {}),
    );
  }
}
