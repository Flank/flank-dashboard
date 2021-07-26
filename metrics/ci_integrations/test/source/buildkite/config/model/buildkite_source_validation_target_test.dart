// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:collection';

import 'package:ci_integration/source/buildkite/config/model/buildkite_source_validation_target.dart';
import 'package:test/test.dart';

void main() {
  group("BuildkiteSourceValidationTarget", () {
    test(
      ".values is unmodifiable list view",
      () {
        expect(BuildkiteSourceValidationTarget.values,
            isA<UnmodifiableListView>());
      },
    );

    test(
      ".values contains all buildkite source validation targets",
      () {
        final expectedConfigFields = [
          BuildkiteSourceValidationTarget.accessToken,
          BuildkiteSourceValidationTarget.organizationSlug,
          BuildkiteSourceValidationTarget.pipelineSlug,
        ];

        expect(
          BuildkiteSourceValidationTarget.values,
          containsAll(expectedConfigFields),
        );
      },
    );
  });
}
