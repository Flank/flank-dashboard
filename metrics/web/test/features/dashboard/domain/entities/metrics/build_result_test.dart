import 'package:metrics/features/dashboard/domain/entities/metrics/build_result.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  final DateTime date = DateTime.utc(2020, 4, 10);
  const Duration duration = Duration(minutes: 14);
  const BuildStatus buildStatus = BuildStatus.successful;
  const String url = 'some url';

  test('Creates BuildResult instance with the given options', () {
    final buildResult = BuildResult(
        date: date, duration: duration, buildStatus: buildStatus, url: url);

    expect(buildResult.date, equals(date));
    expect(buildResult.duration, equals(duration));
    expect(buildResult.buildStatus, equals(buildStatus));
    expect(buildResult.url, equals(url));
  });

  test('Two identical instances of BuildResult are equals', () {
    final firstBuildResult = BuildResult(
        date: date, duration: duration, buildStatus: buildStatus, url: url);
    final secondBuildResult = BuildResult(
        date: date, duration: duration, buildStatus: buildStatus, url: url);

    expect(firstBuildResult, equals(secondBuildResult));
  });
}
