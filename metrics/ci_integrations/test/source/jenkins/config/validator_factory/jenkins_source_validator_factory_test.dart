// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/source/jenkins/config/model/jenkins_source_config.dart';
import 'package:ci_integration/source/jenkins/config/validation_delegate/jenkins_source_validation_delegate.dart';
import 'package:ci_integration/source/jenkins/config/validator_factory/jenkins_source_validator_factory.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("JenkinsSourceValidatorFactory", () {
    const validatorFactory = JenkinsSourceValidatorFactory();

    final config = JenkinsSourceConfig(
      url: 'url',
      jobName: 'jobName',
      username: 'username',
      apiKey: 'apiKey',
    );

    test(
      ".create() throws an ArgumentError if the given config is null",
      () {
        expect(() => validatorFactory.create(null), throwsArgumentError);
      },
    );

    test(
      ".create() returns a jenkins source validator with the jenkins source validation delegate",
      () {
        final validator = validatorFactory.create(config);

        expect(
          validator.validationDelegate,
          isA<JenkinsSourceValidationDelegate>(),
        );
      },
    );

    test(
      ".create() returns a jenkins source validator with the validation result builder",
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
