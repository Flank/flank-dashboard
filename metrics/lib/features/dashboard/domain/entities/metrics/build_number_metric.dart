import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents the build number metric entity.
@immutable
class BuildNumberMetric extends Equatable {
  final int numberOfBuilds;

  @override
  List<Object> get props => [numberOfBuilds];

  /// Creates the [BuildNumberMetric].
  ///
  /// [numberOfBuilds] is the number of builds for the last 7 days.
  const BuildNumberMetric({
    this.numberOfBuilds = 0,
  });
}
