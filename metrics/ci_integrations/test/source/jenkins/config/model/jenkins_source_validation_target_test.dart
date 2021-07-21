// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:collection';

import 'package:ci_integration/source/jenkins/config/model/jenkins_source_validation_target.dart';
import 'package:test/test.dart';

void main() {
  group("JenkinsSourceValidationTarget", () {
    test(
      ".values is unmodifiable list view",
      () {
        expect(
          JenkinsSourceValidationTarget.values,
          isA<UnmodifiableListView>(),
        );
      },
    );

    test(
      ".values contains all jenkins source validation targets",
      () {
        final expectedValidationTargets = [
          JenkinsSourceValidationTarget.url,
          JenkinsSourceValidationTarget.jobName,
          JenkinsSourceValidationTarget.username,
          JenkinsSourceValidationTarget.apiKey,
        ];

        expect(
          JenkinsSourceValidationTarget.values,
          containsAll(expectedValidationTargets),
        );
      },
    );
  });
}
