// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_popup_asset_strategy.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("BuildResultPopupAssetStrategy", () {
    const successfulImage = "icons/successful.svg";
    const failedImage = "icons/failed.svg";
    const unknownImage = "icons/unknown.svg";
    const inProgressAnimation =
        "web/animation/in_progress_popup_build_status.riv";

    const strategy = BuildResultPopupAssetStrategy();

    test(
      ".getAsset() returns the successful image if the given build status is successful",
      () {
        final asset = strategy.getAsset(BuildStatus.successful);

        expect(asset, equals(successfulImage));
      },
    );

    test(
      ".getAsset() returns the failed image if the given build status is failed",
      () {
        final asset = strategy.getAsset(BuildStatus.failed);

        expect(asset, equals(failedImage));
      },
    );

    test(
      ".getAsset() returns the unknown image if the given build status is unknown",
      () {
        final asset = strategy.getAsset(BuildStatus.unknown);

        expect(asset, equals(unknownImage));
      },
    );

    test(
      ".getAsset() returns the in progress animation if the given build status is in progress",
      () {
        final asset = strategy.getAsset(BuildStatus.inProgress);

        expect(asset, equals(inProgressAnimation));
      },
    );

    test(
      ".getAsset() returns null if the given build status is null",
      () {
        final asset = strategy.getAsset(null);

        expect(asset, isNull);
      },
    );
  });
}
