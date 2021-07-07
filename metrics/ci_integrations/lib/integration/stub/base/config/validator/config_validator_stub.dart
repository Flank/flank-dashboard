// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/config.dart';
import 'package:ci_integration/integration/interface/base/config/validation_delegate/validation_delegate.dart';
import 'package:ci_integration/integration/stub/base/config/validation_delegate/validation_delegate_stub.dart';
import 'package:ci_integration/integration/validation/model/validation_result.dart';
import 'package:ci_integration/integration/validation/model/validation_result_builder.dart';

/// An abstract class responsible for validating the [Config].
class ConfigValidatorStub<T extends Config> {
  /// A [ValidationResultBuilder] this validator uses to build
  /// the [ValidationResult].
  final ValidationResultBuilder validationResultBuilder =
      ValidationResultBuilder.forFields([]);

  /// A [ValidationDelegate] this validator uses for [Config]'s
  /// specific fields validation.
  final ValidationDelegate validationDelegate = ValidationDelegateStub();

  /// Validates the given [config].
  Future<ValidationResult> validate(T config) {
    return Future.value(
      ValidationResult(const {}),
    );
  }
}
