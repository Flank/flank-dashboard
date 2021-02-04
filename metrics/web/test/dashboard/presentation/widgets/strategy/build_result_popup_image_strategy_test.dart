// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_popup_image_strategy.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("BuildResultPopupImageStrategy", () {
    const successfulImage = "icons/successful.svg";
    const failedImage = "icons/failed.svg";
    const unknownImage = "icons/unknown.svg";
    const strategy = BuildResultPopupImageStrategy();

    test(
      ".getImageAsset() returns the successful image if the given build status is successful",
      () {
        final actualImage = strategy.getImageAsset(BuildStatus.successful);

        expect(actualImage, equals(successfulImage));
      },
    );

    test(
      ".getImageAsset() returns the failed image if the given build status is failed",
      () {
        final actualImage = strategy.getImageAsset(BuildStatus.failed);

        expect(actualImage, equals(failedImage));
      },
    );

    test(
      ".getImageAsset() returns the unknown image if the given build status is unknown",
      () {
        final actualImage = strategy.getImageAsset(BuildStatus.unknown);

        expect(actualImage, equals(unknownImage));
      },
    );

    test(
      ".getImageAsset() returns null if the given build status is null",
      () {
        final actualImage = strategy.getImageAsset(null);

        expect(actualImage, isNull);
      },
    );
  });
}
