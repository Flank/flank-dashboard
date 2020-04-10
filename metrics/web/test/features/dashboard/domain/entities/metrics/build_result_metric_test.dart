// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:metrics/features/dashboard/domain/entities/metrics/build_result.dart';
import 'package:metrics/features/dashboard/domain/entities/metrics/build_result_metric.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  final buildResult = BuildResult(
    date: DateTime.utc(2020, 4, 10),
    duration: const Duration(minutes: 14),
    buildStatus: BuildStatus.successful,
    url: 'some url',
  );

  test('Creates BuildResultMetric with the given BuildResult instance', () {
    final buildResultMetric = BuildResultMetric(buildResults: [buildResult]);

    expect(buildResultMetric.buildResults, equals([buildResult]));
  });

  test('Two identical instances of BuildResultMetric are equals', () {
    final firstBuildResultMetric =
        BuildResultMetric(buildResults: [buildResult]);
    final secondBuildResultMetric =
        BuildResultMetric(buildResults: [buildResult]);

    expect(firstBuildResultMetric, equals(secondBuildResultMetric));
  });
}
