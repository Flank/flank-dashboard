// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/dashboard/presentation/widgets/strategy/project_build_status_asset_strategy.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matchers.dart';

void main() {
  group("ProjectBuildStatusAssetStrategy", () {
    const successfulImage = "icons/successful_status.svg";
    const failedImage = "icons/failed_status.svg";
    const unknownImage = "icons/unknown_status.svg";
    const darkInProgressAnimation =
        "web/animation/in_progress_project_build_status_dark.riv";
    const lightInProgressAnimation =
        "web/animation/in_progress_project_build_status_light.riv";

    const lightStrategy = ProjectBuildStatusAssetStrategy(isDarkMode: false);
    const darkStrategy = ProjectBuildStatusAssetStrategy(isDarkMode: true);

    test(
      "throws an AssertionError if the given is dark mode is null",
      () {
        expect(
          () => ProjectBuildStatusAssetStrategy(isDarkMode: null),
          throwsAssertionError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        const expectedIsDarkMode = false;

        const strategy = ProjectBuildStatusAssetStrategy(
          isDarkMode: expectedIsDarkMode,
        );

        expect(strategy.isDarkMode, equals(expectedIsDarkMode));
      },
    );

    test(
      ".getAsset() returns the successful image if the given build status is successful",
      () {
        final asset = lightStrategy.getAsset(BuildStatus.successful);

        expect(asset, equals(successfulImage));
      },
    );

    test(
      ".getAsset() returns the failed image if the given build status is failed",
      () {
        final asset = lightStrategy.getAsset(BuildStatus.failed);

        expect(asset, equals(failedImage));
      },
    );

    test(
      ".getAsset() returns the unknown image if the given build status is unknown",
      () {
        final asset = lightStrategy.getAsset(BuildStatus.unknown);

        expect(asset, equals(unknownImage));
      },
    );

    test(
      ".getAsset() returns the light in progress animation if the given build status is in progress and the current theme mode is light",
      () {
        final asset = lightStrategy.getAsset(BuildStatus.inProgress);

        expect(asset, equals(lightInProgressAnimation));
      },
    );

    test(
      ".getAsset() returns the dark in progress animation if the given build status is in progress and the current theme mode is dark",
      () {
        final asset = darkStrategy.getAsset(BuildStatus.inProgress);

        expect(asset, equals(darkInProgressAnimation));
      },
    );

    test(
      ".getAsset() returns null if the given build status is null",
      () {
        final asset = lightStrategy.getAsset(null);

        expect(asset, isNull);
      },
    );
  });
}
