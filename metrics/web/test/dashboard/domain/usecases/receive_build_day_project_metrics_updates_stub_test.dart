// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/domain/repositories/build_day_repository.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_day_project_metrics.dart';
import 'package:metrics/dashboard/domain/usecases/parameters/project_id_param.dart';
import 'package:metrics/dashboard/domain/usecases/receive_build_day_project_metrics_updates_stub.dart';
import 'package:mockito/mockito.dart';

void main() {
  group("ReceiveBuildDayProjectMetricsUpdatesStub", () {
    const projectId = 'id';
    const projectIdParam = ProjectIdParam(projectId);

    final buildDayRepository = _BuildDayRepositoryMock();
    final usecase = ReceiveBuildDayProjectMetricsUpdatesStub(
      buildDayRepository,
    );

    tearDown(() {
      reset(buildDayRepository);
    });

    test(
      "throws an ArgumentError if the given build day repository is null",
      () {
        expect(
          () => ReceiveBuildDayProjectMetricsUpdatesStub(null),
          throwsArgumentError,
        );
      },
    );

    test(
      "successfully creates an instance with the given build day repository",
      () {
        expect(
          () => ReceiveBuildDayProjectMetricsUpdatesStub(buildDayRepository),
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

class _BuildDayRepositoryMock extends Mock implements BuildDayRepository {}
