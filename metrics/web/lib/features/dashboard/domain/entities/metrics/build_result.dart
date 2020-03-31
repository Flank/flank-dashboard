import 'package:meta/meta.dart';
import 'package:metrics_core/metrics_core.dart';

/// Represents the CI build [buildStatus] on specified [date].
///
/// Contains the data about build [url] and build [duration].
@immutable
class BuildResult {
  final DateTime date;
  final Duration duration;
  final BuildStatus buildStatus;
  final String url;

  const BuildResult({
    this.date,
    this.duration,
    this.buildStatus,
    this.url,
  });
}
