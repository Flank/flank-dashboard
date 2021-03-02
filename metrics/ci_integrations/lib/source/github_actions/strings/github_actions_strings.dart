// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

// ignore_for_file: public_member_api_docs

/// Holds the strings used across the Github Actions source integration.
class GithubActionsStrings {
  static const String tokenInvalid = 'The access token is invalid.';
  static const String repositoryOwnerNotFound =
      'A repository owner with a specified name does not exist.';
  static const String repositoryNotFound =
      'A repository with a specified name does not exist.';
  static const String workflowNotFround =
      'A workflow with a specified identifier does not exist.';
  static const String workflowIdentifierInvalid =
      'The workflow identifier is invalid.';
  static const String noWorkflowRunsToValidateJobName =
      "A job name can`t be validated as there are no workflow runs.";
  static const String noJobsToValidateJobName =
      "A job name can`t be validated as there are no workflow run jobs.";
  static const String jobNameInvalid = 'The job name is invalid.';
  static const String noArtifactsToValidateName =
      'An coverage artifact name can`t be validated as there are no workflow run artifacts.';
  static const String coverageArtifactNameInvalid =
      'The coverage artifact name is invalid.';

  static String tokenScopeNotFound(String token) {
    return 'The access token does not have the required $token scope.';
  }
}
