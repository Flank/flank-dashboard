// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/dashboard/domain/entities/collections/date_time_set.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_performance.dart';
import 'package:metrics/dashboard/domain/entities/metrics/performance_metric.dart';
import 'package:test/test.dart';

void main() {
  group("PerformanceMetric", () {
    const averageBuildDuration = Duration(seconds: 2);
    final buildsPerformance = DateTimeSet.from(
      [
        BuildPerformance(
          date: DateTime.utc(2020, 4, 10),
          duration: const Duration(seconds: 2),
        )
      ],
    );

    test(
      "creates an instance with the given data",
      () {
        final performanceMetric = PerformanceMetric(
          averageBuildDuration: averageBuildDuration,
          buildsPerformance: buildsPerformance,
        );

        expect(
          performanceMetric.averageBuildDuration,
          equals(averageBuildDuration),
        );
        expect(performanceMetric.buildsPerformance, equals(buildsPerformance));
      },
    );

    test("has an averageBuildDuration of 0 if no duration is provided", () {
      expect(
        const PerformanceMetric().averageBuildDuration,
        equals(Duration.zero),
      );
    });

    test(
      "two instances with equal fields are identical",
      () {
        final firstPerformanceMetric = PerformanceMetric(
          averageBuildDuration: averageBuildDuration,
          buildsPerformance: buildsPerformance,
        );
        final secondPerformanceMetric = PerformanceMetric(
          averageBuildDuration: averageBuildDuration,
          buildsPerformance: buildsPerformance,
        );

        expect(firstPerformanceMetric, equals(secondPerformanceMetric));
      },
    );
  });
}
