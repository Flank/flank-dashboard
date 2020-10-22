import 'package:metrics/dashboard/presentation/widgets/strategy/project_build_status_image_strategy.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectBuildStatusImageStrategy", () {
    const successfulImage = "icons/successful_status.svg";
    const failedImage = "icons/failed_status.svg";
    const unknownImage = "icons/unknown_status.svg";
    const imageStrategy = ProjectBuildStatusImageStrategy();

    test(
      ".getIconImage() returns the successful image if the given build status is successful",
      () {
        final actualStyle = imageStrategy.getIconImage(BuildStatus.successful);

        expect(actualStyle, equals(successfulImage));
      },
    );

    test(
      ".getIconImage() returns the failed image if the given build status is failed",
      () {
        final actualStyle = imageStrategy.getIconImage(BuildStatus.failed);

        expect(actualStyle, equals(failedImage));
      },
    );

    test(
      ".getIconImage() returns the unknown image if the given build status is unknown",
      () {
        final actualStyle = imageStrategy.getIconImage(BuildStatus.unknown);

        expect(actualStyle, equals(unknownImage));
      },
    );

    test(
      ".getIconImage() returns null if the given build status is null",
      () {
        final actualStyle = imageStrategy.getIconImage(null);

        expect(actualStyle, isNull);
      },
    );
  });
}
