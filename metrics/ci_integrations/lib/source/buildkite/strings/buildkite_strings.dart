// ignore_for_file: public_member_api_docs

/// Holds the strings used across the Buildkite source integration.
class BuildkiteStrings {
  static const String tokenInvalid = 'The access token is invalid.';
  static const String tokenDoesNotHaveReadBuildsScope =
      "The access token does not have the required 'read_builds' scope.";
  static const String tokenDoesNotHaveReadArtifactsScope =
      "This token does not have the 'read_artifacts' scope, so the 'sync' command should be run with the 'no-coverage' flag or the 'read_artifacts' scope should be provided.";
  static const String pipelineNotFound =
      'The pipeline with such slug does not exist.';
  static const String organizationNotFound =
      'The organization with such slug does not exist.';
}
