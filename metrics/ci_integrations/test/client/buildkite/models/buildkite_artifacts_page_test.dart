// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/buildkite/models/buildkite_artifact.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_artifacts_page.dart';
import 'package:test/test.dart';

void main() {
  group("BuildkiteArtifactsPage", () {
    const page = 1;
    const perPage = 1;
    const nextPageUrl = 'url';
    const values = [BuildkiteArtifact(id: "1"), BuildkiteArtifact(id: "2")];

    test("creates an instance with the given values", () {
      const runsPage = BuildkiteArtifactsPage(
        page: page,
        perPage: perPage,
        nextPageUrl: nextPageUrl,
        values: values,
      );

      expect(runsPage.page, equals(page));
      expect(runsPage.perPage, equals(perPage));
      expect(runsPage.nextPageUrl, equals(nextPageUrl));
      expect(runsPage.values, equals(values));
    });
  });
}
