import 'package:ci_integration/source/buildkite/config/model/buildkite_source_config.dart';

/// A class that holds the test data for the [BuildkiteSourceConfig].
class BuildkiteConfigTestData {
  /// An access token to use in tests.
  static const String accessToken = 'token';

  /// An organization slug to use in tests.
  static const String organizationSlug = 'organization-slug';

  /// A pipeline slug to use in tests.
  static const String pipelineSlug = 'pipeline-slug';

  /// A decoded JSON object with Buildkite test configurations.
  static const Map<String, dynamic> sourceConfigMap = {
    'access_token': accessToken,
    'organization_slug': organizationSlug,
    'pipeline_slug': pipelineSlug,
  };

  /// A source config to use in tests.
  static final sourceConfig = BuildkiteSourceConfig(
    accessToken: accessToken,
    organizationSlug: organizationSlug,
    pipelineSlug: pipelineSlug,
  );
}
