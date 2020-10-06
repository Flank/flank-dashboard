import 'package:equatable/equatable.dart';

/// Represents the build number metric entity.
class BuildNumberMetric extends Equatable {
  /// An amount of the builds.
  final int numberOfBuilds;

  @override
  List<Object> get props => [numberOfBuilds];

  /// Creates the [BuildNumberMetric].
  ///
  /// The [numberOfBuilds] default value is `0`.
  const BuildNumberMetric({
    this.numberOfBuilds = 0,
  });
}
