// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/config.dart';
import 'package:ci_integration/integration/interface/base/config/validator/config_validator.dart';
import 'package:ci_integration/integration/interface/base/config/validator_factory/config_validator_factory.dart';
import 'package:ci_integration/integration/stub/base/config/validator/validator_stub.dart';

/// A stub implementation of the [ConfigValidatorFactory].
class ValidatorFactoryStub<T extends Config>
    implements ConfigValidatorFactory<T> {
  /// Creates a new instance of the [ValidatorFactoryStub].
  const ValidatorFactoryStub();

  @override
  ConfigValidator<T> create(T config) {
    return ValidatorStub<T>();
  }
}
