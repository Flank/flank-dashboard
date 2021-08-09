// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/stub/base/config/validator/config_validator_stub.dart';
import 'package:test/test.dart';

import '../../../../../test_utils/config_stub.dart';

void main() {
  group("ConfigValidatorStub", () {
    final config = ConfigStub();
    final validator = ConfigValidatorStub();

    test(
      ".validate() returns a non-null validation result",
      () async {
        final result = await validator.validate(config);

        expect(result, isNotNull);
      },
    );

    test(
      ".validate() returns a validation result with an empty field validation results map",
      () async {
        final result = await validator.validate(config);

        final fieldResults = result.results;

        expect(fieldResults, isEmpty);
      },
    );
  });
}
