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
      'A pipeline with a specified slug does not exist.';
  static const String organizationNotFound =
      'An organization with a specified slug does not exist.';
  static const String tokenInvalidInterruptReason =
      "Can't be validated as the provided access token is invalid.";
  static const String noScopesToValidateOrganization =
      "An organization can`t be validated as the provided access token does not have the 'read_organization' scope.";
  static const String organizationCantBeValidatedInterruptReason =
      "Can't be validated as the provided organization slug can't be validated.";
  static const String organizationInvalidInterruptReason =
      "Can't be validated as the provided organization slug is invalid.";
  static const String noScopesToValidatePipeline =
      "A pipeline can`t be validated as the provided access token does not have the 'read_pipelines' scope.";
}
