// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:collection';

import 'package:ci_integration/source/github_actions/config/model/github_actions_source_validation_target.dart';
import 'package:test/test.dart';

void main() {
  group("GithubActionsSourceValidationTarget", () {
    test(
      ".values is unmodifiable list view",
      () {
        expect(
          GithubActionsSourceValidationTarget.values,
          isA<UnmodifiableListView>(),
        );
      },
    );

    test(
      ".values contains all github actions source validation targets",
      () {
        final expectedValidationTargets = [
          GithubActionsSourceValidationTarget.accessToken,
          GithubActionsSourceValidationTarget.repositoryOwner,
          GithubActionsSourceValidationTarget.repositoryName,
          GithubActionsSourceValidationTarget.workflowIdentifier,
          GithubActionsSourceValidationTarget.jobName,
          GithubActionsSourceValidationTarget.coverageArtifactName,
        ];

        expect(
          GithubActionsSourceValidationTarget.values,
          containsAll(expectedValidationTargets),
        );
      },
    );
  });
}
