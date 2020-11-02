import 'package:ci_integration/client/buildkite/models/buildkite_artifact.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_artifacts_page.dart';
import 'package:test/test.dart';

// https://github.com/platform-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("BuildkiteArtifactsPage", () {
    const page = 1;
    const perPage = 1;
    const nextPageUrl = 'url';
    const values = [BuildkiteArtifact(id: "1"), BuildkiteArtifact(id: "2")];

    test("creates an instance with the given values", () {
      final runsPage = BuildkiteArtifactsPage(
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
