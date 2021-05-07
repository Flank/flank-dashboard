// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_day_project_metrics.dart';
import 'package:metrics/dashboard/domain/usecases/parameters/project_id_param.dart';
import 'package:metrics/dashboard/domain/usecases/receive_build_day_project_metrics_updates_stub.dart';

void main() {
  group("ReceiveBuildDayProjectMetricsUpdatesStub", () {
    const projectId = 'id';
    const projectIdParam = ProjectIdParam(projectId);

    final usecase = ReceiveBuildDayProjectMetricsUpdatesStub();

    test(
      "successfully creates an instance",
      () {
        expect(
          () => ReceiveBuildDayProjectMetricsUpdatesStub(),
          returnsNormally,
        );
      },
    );

    test(
      ".call() returns an empty stream",
      () {
        final metricsStream = usecase.call(projectIdParam);

        final metricsMatcher = isA<BuildDayProjectMetrics>();

        expect(metricsStream, neverEmits(metricsMatcher));
      },
    );
  });
}
