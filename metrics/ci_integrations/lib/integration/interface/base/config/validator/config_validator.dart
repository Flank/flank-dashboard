// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/config.dart';
import 'package:ci_integration/integration/interface/base/config/validation_delegate/validation_delegate.dart';

/// An abstract class responsible for validating the [Config].
abstract class ConfigValidator<T extends Config> {
  /// A [ValidationDelegate] this validator uses for [Config]'s
  /// specific fields validation.
  final ValidationDelegate validationDelegate;

  /// A [StringBuffer] that this validator uses to accumulate error messages.
  final StringBuffer errorBuffer = StringBuffer();

  /// Creates a new instance of the [ConfigValidator] with the
  /// given [validationDelegate].
  ///
  /// Throws an [ArgumentError] if the [validationDelegate] is `null`.
  ConfigValidator(
    this.validationDelegate,
  ) {
    ArgumentError.checkNotNull(validationDelegate);
  }

  /// Validates the given [config].
  ///
  /// Throws a [ConfigValidationError] if the given [config] is not valid.
  Future<void> validate(T config);

  /// Adds an error message to the [errorBuffer] based on the given
  /// [configField] and [additionalContext].
  void addErrorMessage(String configField, [String additionalContext]) {
    final errorMessage = _generateErrorMessage(configField, additionalContext);

    errorBuffer.writeln(errorMessage);
  }

  /// Generates an error message from the given [configField]
  /// and [additionalContext].
  ///
  /// Does not add the [additionalContext] if it is `null`.
  String _generateErrorMessage(String configField, [String additionalContext]) {
    String message = 'A $configField from the $T may be incorrect.';

    if (additionalContext != null) {
      message = '$message \nAdditional context: $additionalContext';
    }

    return message;
  }
}
