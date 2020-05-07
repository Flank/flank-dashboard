import 'package:equatable/equatable.dart';
import 'package:metrics_core/metrics_core.dart';

/// Represents the CI build [buildStatus] on specified [date].
///
/// Contains the data about build [url] and build [duration].
class BuildResult extends Equatable {
  final DateTime date;
  final Duration duration;
  final BuildStatus buildStatus;
  final String url;

  @override
  List<Object> get props => [date, duration, buildStatus, url];

  const BuildResult({
    this.date,
    this.duration,
    this.buildStatus,
    this.url,
  });
}
