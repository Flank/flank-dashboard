// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/dashboard/domain/entities/metrics/build_number_metric.dart';
import 'package:test/test.dart';

void main() {
  group("BuildNumberMetric", () {
    const buildNumber = 1;

    test(
      "can be created with the given build number",
      () {
        const buildNumberMetric =
            BuildNumberMetric(numberOfBuilds: buildNumber);

        expect(buildNumberMetric.numberOfBuilds, equals(buildNumber));
      },
    );

    test(
      "two instances with the equal number of builds are equal",
      () {
        const firstBuildNumberMetric = BuildNumberMetric(
          numberOfBuilds: buildNumber,
        );
        const secondBuildNumberMetric = BuildNumberMetric(
          numberOfBuilds: buildNumber,
        );

        expect(firstBuildNumberMetric, equals(secondBuildNumberMetric));
      },
    );

    test(
      "creates a new instance with 0 number of builds if nothing is passed",
      () {
        const buildNumberMetric = BuildNumberMetric();

        expect(buildNumberMetric.numberOfBuilds, equals(0));
      },
    );
  });
}
