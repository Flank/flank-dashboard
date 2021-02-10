// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/builder/validation_result_builder.dart';
import 'package:ci_integration/integration/interface/base/config/model/config.dart';
import 'package:ci_integration/integration/interface/base/config/model/validation_result.dart';
import 'package:ci_integration/integration/interface/base/config/validation_delegate/validation_delegate.dart';

/// An abstract class responsible for validating the [Config].
abstract class ConfigValidator<T extends Config, V extends ValidationDelegate,
    R extends ValidationResult> {
  /// A [ValidationDelegate] this validator uses for [Config]'s
  /// specific fields validation.
  final V validationDelegate;

  /// A [ValidationResultBuilder] this validator uses
  /// to create a [ValidationResult].
  final ValidationResultBuilder<R> validationResultBuilder;

  /// Creates a new instance of the [ConfigValidator] with the
  /// given [validationDelegate] and [validationResultBuilder].
  ///
  /// Throws an [ArgumentError] if the [validationDelegate]
  /// or [validationResultBuilder] is `null`.
  ConfigValidator(
    this.validationDelegate,
    this.validationResultBuilder,
  ) {
    ArgumentError.checkNotNull(validationDelegate);
    ArgumentError.checkNotNull(validationResultBuilder);
  }

  /// Validates the given [config].
  ///
  /// Throws a [ConfigValidationError] if the given [config] is not valid.
  Future<void> validate(T config);
}
