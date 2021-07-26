// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/jenkins/jenkins_client.dart';
import 'package:ci_integration/integration/stub/base/config/validator/config_validator_stub.dart';
import 'package:ci_integration/integration/stub/base/config/validator_factory/config_validator_factory_stub.dart';
import 'package:ci_integration/integration/validation/model/validation_result_builder.dart';
import 'package:ci_integration/source/jenkins/config/model/jenkins_source_config.dart';
import 'package:ci_integration/source/jenkins/config/model/jenkins_source_config_field.dart';
import 'package:ci_integration/source/jenkins/config/validation_delegate/jenkins_source_validation_delegate.dart';
import 'package:ci_integration/source/jenkins/config/validator/jenkins_source_validator.dart';
import 'package:ci_integration/util/authorization/authorization.dart';

/// A factory class that provides a method
/// for creating [JenkinsSourceValidator].
class JenkinsSourceValidatorFactory
    implements ConfigValidatorFactoryStub<JenkinsSourceConfig> {
  /// Creates a new instance of the [JenkinsSourceValidatorFactory].
  const JenkinsSourceValidatorFactory();

  @override
  ConfigValidatorStub<JenkinsSourceConfig> create(
    JenkinsSourceConfig config,
  ) {
    ArgumentError.checkNotNull(config, 'config');

    final authorization = BasicAuthorization(config.username, config.apiKey);

    final jenkinsClient = JenkinsClient(
      jenkinsUrl: config.url,
      authorization: authorization,
    );

    final validationDelegate = JenkinsSourceValidationDelegate(jenkinsClient);

    final validationResultBuilder = ValidationResultBuilder.forFields(
      JenkinsSourceConfigField.values,
    );

    return JenkinsSourceValidator(validationDelegate, validationResultBuilder);
  }
}
