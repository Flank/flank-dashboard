import 'package:meta/meta.dart';

/// Represents the build number metric entity.
@immutable
class BuildNumberMetric {
  final int numberOfBuilds;

  /// Creates the [BuildNumberMetric].
  ///
  /// [numberOfBuilds] is the number of builds that was used to calculate this metric.
  const BuildNumberMetric({
    this.numberOfBuilds = 0,
  });
}
