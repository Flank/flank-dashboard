// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:metrics/dashboard/domain/entities/metrics/build_number_metrics.dart';
import 'package:test/test.dart';

void main() {
  group("BuildNumberMetrics", () {
    const buildNumber = 1;

    test(
      "can be created with the given build number",
      () {
        final buildNumberMetrics =
            BuildNumberMetrics(numberOfBuilds: buildNumber);

        expect(buildNumberMetrics.numberOfBuilds, equals(buildNumber));
      },
    );

    test(
      "two instances with the equal number of builds are equal",
      () {
        final firstBuildNumberMetrics = BuildNumberMetrics(
          numberOfBuilds: buildNumber,
        );
        final secondBuildNumberMetrics = BuildNumberMetrics(
          numberOfBuilds: buildNumber,
        );

        expect(firstBuildNumberMetrics, equals(secondBuildNumberMetrics));
      },
    );

    test(
      "creates a new instance with 0 number of builds if nothing is passed",
      () {
        final buildNumberMetrics = BuildNumberMetrics();

        expect(buildNumberMetrics.numberOfBuilds, equals(0));
      },
    );
  });
}
