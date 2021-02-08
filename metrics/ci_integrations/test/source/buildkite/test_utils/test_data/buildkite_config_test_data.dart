// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/source/buildkite/config/model/buildkite_source_config.dart';

/// A class that holds the test data for the [BuildkiteSourceConfig].
class BuildkiteConfigTestData {
  /// An access token to use in tests.
  static const String accessToken = 'token';

  /// A pipeline slug to use in tests.
  static const String pipelineSlug = 'pipeline-slug';

  /// An organization slug to use in tests.
  static const String organizationSlug = 'organization-slug';

  /// A decoded JSON object with Buildkite test configurations.
  static const Map<String, dynamic> sourceConfigMap = {
    'access_token': accessToken,
    'pipeline_slug': pipelineSlug,
    'organization_slug': organizationSlug,
  };

  /// A source config to use in tests.
  static final sourceConfig = BuildkiteSourceConfig(
    accessToken: accessToken,
    pipelineSlug: pipelineSlug,
    organizationSlug: organizationSlug,
  );
}
