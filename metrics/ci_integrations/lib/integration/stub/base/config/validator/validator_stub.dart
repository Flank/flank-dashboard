// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/config.dart';
import 'package:ci_integration/integration/interface/base/config/validation_delegate/validation_delegate.dart';
import 'package:ci_integration/integration/interface/base/config/validator/config_validator.dart';
import 'package:ci_integration/integration/stub/base/config/validation_delegate/validation_delegate_stub.dart';
import 'package:metrics_core/metrics_core.dart';

/// A stub implementation of the [ConfigValidator].
class ValidatorStub<T extends Config> implements ConfigValidator<T> {
  @override
  final ValidationResultBuilder validationResultBuilder =
      ValidationResultBuilder.forTargets([]);

  @override
  final ValidationDelegate validationDelegate = ValidationDelegateStub();

  @override
  Future<ValidationResult> validate(T config) {
    return Future.value(
      ValidationResult(const {}),
    );
  }
}
