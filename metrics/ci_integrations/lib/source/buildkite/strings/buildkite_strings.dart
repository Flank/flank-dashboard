// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

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
  static const String accessToken = 'accessToken';
  static const String tokenInvalidInterruptReason =
      "Can't be validated as the provided access token is invalid.";
  static const String organizationSlug = 'organizationSlug';
  static const String noScopesToValidateOrganization =
      "Organization can`t be validated as the provided access token does not have the 'read_organization' scope.";
  static const String organizationCantBeValidatedInterruptReason =
      "Can't be validated as the provided organization slug can't be validated.";
  static const String organizationInvalidInterruptReason =
      "Can't be validated as the provided organization slug is invalid.";
  static const String pipelineSlug = 'pipelineSlug';
  static const String noScopesToValidatePipeline =
      "Pipeline can`t be validated as the provided access token does not have the 'read_pipelines' scope.";
}
