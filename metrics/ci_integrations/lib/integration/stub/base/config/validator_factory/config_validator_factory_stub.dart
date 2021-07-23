// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/config.dart';
import 'package:ci_integration/integration/interface/base/config/validator_factory/config_validator_factory.dart';
import 'package:ci_integration/integration/stub/base/config/validator/config_validator_stub.dart';

/// A stub implementation of the [ConfigValidatorFactory].
class ConfigValidatorFactoryStub<T extends Config> {
  /// Creates a new instance of the [ConfigValidatorFactoryStub].
  const ConfigValidatorFactoryStub();

  /// Creates an instance of the [ConfigValidatorStub] using the given [config].
  ConfigValidatorStub<T> create(T config) {
    return ConfigValidatorStub<T>();
  }
}
