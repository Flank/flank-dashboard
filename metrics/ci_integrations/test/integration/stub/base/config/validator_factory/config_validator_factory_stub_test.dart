// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/stub/base/config/validator/validator_stub.dart';
import 'package:ci_integration/integration/stub/base/config/validator_factory/config_validator_factory_stub.dart';
import 'package:ci_integration/integration/validation/model/validation_result_builder.dart';
import 'package:test/test.dart';

import '../../../../../test_utils/config_stub.dart';

void main() {
  group("ConfigValidatorFactoryStub", () {
    final config = ConfigStub();
    const configFactory = ConfigValidatorFactoryStub();

    test(
      ".create() returns a validator stub",
      () {
        final result = configFactory.create(config);

        expect(result, isA<ValidatorStub>());
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
