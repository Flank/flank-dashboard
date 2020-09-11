import 'package:equatable/equatable.dart';

/// Represents the build number metrics entity.
class BuildNumberMetrics extends Equatable {
  final int numberOfBuilds;

  @override
  List<Object> get props => [numberOfBuilds];

  /// Creates the [BuildNumberMetrics].
  ///
  /// [numberOfBuilds] is the number of builds for the last 7 days.
  const BuildNumberMetrics({
    this.numberOfBuilds = 0,
  });
}
