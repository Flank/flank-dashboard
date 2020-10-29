import 'package:ci_integration/client/buildkite/models/buildkite_build.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_builds_page.dart';
import 'package:test/test.dart';

// https://github.com/platform-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

void main() {
  group("BuildkiteBuildsPage", () {
    const page = 1;
    const perPage = 1;
    const nextPageUrl = 'url';
    const values = [BuildkiteBuild(id: 1), BuildkiteBuild(id: 2)];

    test("creates an instance with the given values", () {
      final runsPage = BuildkiteBuildsPage(
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
