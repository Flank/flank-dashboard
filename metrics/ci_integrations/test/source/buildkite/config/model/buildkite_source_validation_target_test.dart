// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:collection';

import 'package:ci_integration/source/buildkite/config/model/buildkite_source_validation_target.dart';
import 'package:test/test.dart';

void main() {
  group("BuildkiteSourceConfigField", () {
    test(
      ".values is unmodifiable list view",
      () {
        expect(BuildkiteSourceConfigField.values, isA<UnmodifiableListView>());
      },
    );

    test(
      ".values contains all buildkite source config fields",
      () {
        final expectedConfigFields = [
          BuildkiteSourceConfigField.accessToken,
          BuildkiteSourceConfigField.organizationSlug,
          BuildkiteSourceConfigField.pipelineSlug,
        ];

        expect(
          BuildkiteSourceConfigField.values,
          containsAll(expectedConfigFields),
        );
      },
    );
  });
}
