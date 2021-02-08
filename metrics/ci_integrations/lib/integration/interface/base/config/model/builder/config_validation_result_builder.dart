// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/config_field_validation_result.dart';
import 'package:ci_integration/integration/interface/base/config/model/config_validation_result.dart';

///
abstract class ConfigValidationResultBuilder<T extends ConfigValidationResult> {
  /// An auth validation result of a specific [Config].
  final ConfigFieldValidationResult authValidationResult;

  ///
  final String interruptReason;

  /// Creates a new instance of the [ConfigValidationResultBuilder] with the
  /// given [authValidationResult] and [interruptReason].
  const ConfigValidationResultBuilder({
    this.authValidationResult,
    this.interruptReason,
  });

  ///
  T build();

  ///
  void setAuthResult(ConfigFieldValidationResult authResult);

  ///
  void setInterruptReason(String reason);
}
