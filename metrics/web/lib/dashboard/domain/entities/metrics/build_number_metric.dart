import 'package:equatable/equatable.dart';

/// Represents the build number metric entity.
class BuildNumberMetric extends Equatable {
  /// A number of builds.
  final int numberOfBuilds;

  @override
  List<Object> get props => [numberOfBuilds];

  /// Creates a new instance of the [BuildNumberMetric].
  ///
  /// The [numberOfBuilds] default value is `0`.
  const BuildNumberMetric({
    this.numberOfBuilds = 0,
  });
}
