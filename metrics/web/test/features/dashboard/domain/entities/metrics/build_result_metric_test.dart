// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:metrics/features/dashboard/domain/entities/metrics/build_result.dart';
import 'package:metrics/features/dashboard/domain/entities/metrics/build_result_metric.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("BuildResultMetric", () {
    final buildResult = BuildResult(
      date: DateTime.utc(2020, 4, 10),
      duration: const Duration(minutes: 14),
      buildStatus: BuildStatus.successful,
      url: 'some url',
    );
    test(
      'creates an instance with the given BuildResult',
      () {
        final buildResultMetric =
            BuildResultMetric(buildResults: [buildResult]);

        expect(buildResultMetric.buildResults, equals([buildResult]));
      },
    );

    test(
      'two instances with the equal build results are equal',
      () {
        final firstBuildResultMetric =
            BuildResultMetric(buildResults: [buildResult]);
        final secondBuildResultMetric =
            BuildResultMetric(buildResults: [buildResult]);

        expect(firstBuildResultMetric, equals(secondBuildResultMetric));
      },
    );
  });
}
