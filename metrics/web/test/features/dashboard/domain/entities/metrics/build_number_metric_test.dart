import 'package:metrics/features/dashboard/domain/entities/metrics/build_number_metric.dart';
import 'package:test/test.dart';

void main() {
  const buildNumber = 1;

  test('Creates BuildNumberMetric instance with the given build number', () {
    final buildNumberMetric = BuildNumberMetric(numberOfBuilds: buildNumber);

    expect(buildNumberMetric.numberOfBuilds, buildNumber);
  });

  test('Two identical instances of BuildNumberMetric are equals', () {
    final firstBuildNumberMetric =
        BuildNumberMetric(numberOfBuilds: buildNumber);
    final secondBuildNumberMetric =
        BuildNumberMetric(numberOfBuilds: buildNumber);

    expect(firstBuildNumberMetric, equals(secondBuildNumberMetric));
  });
}
