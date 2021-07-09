// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/buildkite/buildkite_client.dart';
import 'package:ci_integration/integration/interface/base/config/validator/config_validator.dart';
import 'package:ci_integration/integration/interface/base/config/validator_factory/config_validator_factory.dart';
import 'package:ci_integration/source/buildkite/config/model/buildkite_source_config.dart';
import 'package:ci_integration/source/buildkite/config/model/buildkite_source_validation_target.dart';
import 'package:ci_integration/source/buildkite/config/validation_delegate/buildkite_source_validation_delegate.dart';
import 'package:ci_integration/source/buildkite/config/validator/buildkite_source_validator.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:metrics_core/metrics_core.dart';

/// A factory class that provides a method for creating [BuildkiteSourceConfig].
class BuildkiteSourceValidatorFactory
    implements ConfigValidatorFactory<BuildkiteSourceConfig> {
  /// Creates a new instance of the [BuildkiteSourceValidatorFactory].
  const BuildkiteSourceValidatorFactory();

  @override
  ConfigValidator<BuildkiteSourceConfig> create(BuildkiteSourceConfig config) {
    ArgumentError.checkNotNull(config, 'config');

    final authorization = BearerAuthorization(config.accessToken);

    final buildkiteClient = BuildkiteClient(
      organizationSlug: config.organizationSlug,
      authorization: authorization,
    );

    final validationDelegate = BuildkiteSourceValidationDelegate(
      buildkiteClient,
    );

    final validationResultBuilder = ValidationResultBuilder.forTargets(
      BuildkiteSourceValidationTarget.values,
    );

    return BuildkiteSourceValidator(
      validationDelegate,
      validationResultBuilder,
    );
  }
}
