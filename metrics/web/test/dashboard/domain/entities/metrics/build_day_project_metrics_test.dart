// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_day_project_metrics.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_number_metric.dart';
import 'package:metrics/dashboard/domain/entities/metrics/performance_metric.dart';

void main() {
  group("BuildDayProjectMetrics", () {
    const projectId = 'id';
    const buildNumberMetric = BuildNumberMetric();
    const performanceMetric = PerformanceMetric();

    test(
      "creates a new instance with the given parameters",
      () {
        const buildDayProjectMetrics = BuildDayProjectMetrics(
          projectId: projectId,
          buildNumberMetric: buildNumberMetric,
          performanceMetric: performanceMetric,
        );

        expect(buildDayProjectMetrics.projectId, equals(projectId));
        expect(
          buildDayProjectMetrics.buildNumberMetric,
          equals(buildNumberMetric),
        );
        expect(
          buildDayProjectMetrics.performanceMetric,
          equals(performanceMetric),
        );
      },
    );

    test(
      "equals to another BuildDayProjectMetrics with the same parameters",
      () {
        const buildDayProjectMetrics = BuildDayProjectMetrics(
          projectId: projectId,
          buildNumberMetric: buildNumberMetric,
          performanceMetric: performanceMetric,
        );

        const anotherBuildDayProjectMetrics = BuildDayProjectMetrics(
          projectId: projectId,
          buildNumberMetric: buildNumberMetric,
          performanceMetric: performanceMetric,
        );

        expect(buildDayProjectMetrics, equals(anotherBuildDayProjectMetrics));
      },
    );
  });
}
