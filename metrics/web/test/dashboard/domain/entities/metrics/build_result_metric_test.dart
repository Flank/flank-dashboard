// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:metrics/dashboard/domain/entities/metrics/build_result.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_result_metrics.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("BuildResultMetrics", () {
    final buildResult = BuildResult(
      date: DateTime.utc(2020, 4, 10),
      duration: const Duration(minutes: 14),
      buildStatus: BuildStatus.successful,
      url: 'some url',
    );
    test(
      'creates an instance with the given BuildResult',
      () {
        final buildResultMetrics =
            BuildResultMetrics(buildResults: [buildResult]);

        expect(buildResultMetrics.buildResults, equals([buildResult]));
      },
    );

    test(
      'two instances with the equal build results are equal',
      () {
        final firstBuildResultMetrics =
            BuildResultMetrics(buildResults: [buildResult]);
        final secondBuildResultMetrics =
            BuildResultMetrics(buildResults: [buildResult]);

        expect(firstBuildResultMetrics, equals(secondBuildResultMetrics));
      },
    );
  });
}
