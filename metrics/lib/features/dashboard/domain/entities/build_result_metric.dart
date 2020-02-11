import 'package:metrics/features/dashboard/domain/entities/build.dart';

/// Represents the CI build [result] on specified [date].
///
/// Contains the data about build [url] and build [duration].
class BuildResultMetric {
  final DateTime date;
  final Duration duration;
  final BuildResult result;
  final String url;

  BuildResultMetric({
    this.date,
    this.duration,
    this.result,
    this.url,
  });
}
