// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/stub/base/config/validation_delegate/validation_delegate_stub.dart';
import 'package:ci_integration/integration/stub/base/config/validator/config_validator_stub.dart';
import 'package:ci_integration/integration/stub/base/config/validator_factory/config_validator_factory_stub.dart';
import 'package:ci_integration/integration/validation/model/validation_result_builder.dart';
import 'package:test/test.dart';

import '../../../../../test_utils/config_stub.dart';

void main() {
  group("ConfigValidatorFactoryStub", () {
    final config = ConfigStub();
    const configFactory = ConfigValidatorFactoryStub();

    test(
      ".create() returns a config validator stub",
      () {
        final result = configFactory.create(config);

        expect(result, isA<ConfigValidatorStub>());
      },
    );

    test(
      ".create() returns a validator stub with the validation delegate stub as a validation delegate",
      () {
        final result = configFactory.create(config);

        final delegate = result.validationDelegate;

        expect(delegate, isA<ValidationDelegateStub>());
      },
    );

    test(
      ".create() returns a validator stub with the non-null validation result builder",
      () {
        final result = configFactory.create(config);

        final builder = result.validationResultBuilder;

        expect(builder, isA<ValidationResultBuilder>());
      },
    );
  });
}
