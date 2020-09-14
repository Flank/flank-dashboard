import 'package:equatable/equatable.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_result.dart';

/// Represents the build results metric entity.
class BuildResultMetric extends Equatable {
  final List<BuildResult> buildResults;

  @override
  List<Object> get props => [buildResults];

  /// Creates the [BuildResultMetric].
  ///
  /// [buildResults] represents the results of several builds.
  const BuildResultMetric({this.buildResults = const []});
}
