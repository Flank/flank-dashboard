// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/source/buildkite/config/model/buildkite_source_config.dart';
import 'package:ci_integration/source/buildkite/config/validation_delegate/buildkite_source_validation_delegate.dart';
import 'package:ci_integration/source/buildkite/config/validator/buildkite_source_validator.dart';
import 'package:ci_integration/source/buildkite/config/validator_factory/buildkite_source_validator_factory.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

//ignore_for_file: avoid_redundant_argument_values

void main() {
  group("BuildkiteSourceValidatorFactory", () {
    const validatorFactory = BuildkiteSourceValidatorFactory();

    final config = BuildkiteSourceConfig(
      accessToken: 'token',
      organizationSlug: 'slug',
      pipelineSlug: 'slug',
    );

    test(
      ".create() throws an ArgumentError if the given config is null",
      () {
        expect(() => validatorFactory.create(null), throwsArgumentError);
      },
    );

    test(
      ".create() returns a buildkite source validator",
      () {
        final validator = validatorFactory.create(config);

        expect(validator, isA<BuildkiteSourceValidator>());
      },
    );

    test(
      ".create() returns a buildkite source validator with the buildkite source validation delegate",
      () {
        final validator = validatorFactory.create(config);

        expect(
          validator.validationDelegate,
          isA<BuildkiteSourceValidationDelegate>(),
        );
      },
    );

    test(
      ".create() returns a buildkite source validator with the validation result builder",
      () {
        final validator = validatorFactory.create(config);

        expect(
          validator.validationResultBuilder,
          isA<ValidationResultBuilder>(),
        );
      },
    );
  });
}
