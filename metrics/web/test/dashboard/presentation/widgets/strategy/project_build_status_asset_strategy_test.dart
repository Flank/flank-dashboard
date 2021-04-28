// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/dashboard/presentation/widgets/strategy/project_build_status_asset_strategy.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectBuildStatusAssetStrategy", () {
    const successfulImage = "icons/successful_status.svg";
    const failedImage = "icons/failed_status.svg";
    const unknownImage = "icons/unknown_status.svg";
    const inProgressImage = "icons/in_progress_status.svg";
    const strategy = ProjectBuildStatusAssetStrategy();

    test(
      ".getAsset() returns the successful image if the given build status is successful",
      () {
        final actualImage = strategy.getAsset(BuildStatus.successful);

        expect(actualImage, equals(successfulImage));
      },
    );

    test(
      ".getAsset() returns the failed image if the given build status is failed",
      () {
        final actualImage = strategy.getAsset(BuildStatus.failed);

        expect(actualImage, equals(failedImage));
      },
    );

    test(
      ".getAsset() returns the unknown image if the given build status is unknown",
      () {
        final actualImage = strategy.getAsset(BuildStatus.unknown);

        expect(actualImage, equals(unknownImage));
      },
    );

    test(
      ".getAsset() returns the in progress image if the given build status is in progress",
      () {
        final actualImage = strategy.getAsset(BuildStatus.inProgress);

        expect(actualImage, equals(inProgressImage));
      },
    );

    test(
      ".getAsset() returns null if the given build status is null",
      () {
        final actualImage = strategy.getAsset(null);

        expect(actualImage, isNull);
      },
    );
  });
}
