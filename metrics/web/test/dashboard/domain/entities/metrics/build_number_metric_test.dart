// https://github.com/platform-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:metrics/dashboard/domain/entities/metrics/build_number_metric.dart';
import 'package:test/test.dart';

void main() {
  group("BuildNumberMetric", () {
    const buildNumber = 1;

    test(
      "can be created with the given build number",
      () {
        final buildNumberMetric =
            BuildNumberMetric(numberOfBuilds: buildNumber);

        expect(buildNumberMetric.numberOfBuilds, equals(buildNumber));
      },
    );

    test(
      "two instances with the equal number of builds are equal",
      () {
        final firstBuildNumberMetric = BuildNumberMetric(
          numberOfBuilds: buildNumber,
        );
        final secondBuildNumberMetric = BuildNumberMetric(
          numberOfBuilds: buildNumber,
        );

        expect(firstBuildNumberMetric, equals(secondBuildNumberMetric));
      },
    );

    test(
      "creates a new instance with 0 number of builds if nothing is passed",
      () {
        final buildNumberMetric = BuildNumberMetric();

        expect(buildNumberMetric.numberOfBuilds, equals(0));
      },
    );
  });
}
