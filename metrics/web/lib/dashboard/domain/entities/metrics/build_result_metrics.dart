import 'package:equatable/equatable.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_result.dart';

/// Represents the build results metrics entity.
class BuildResultMetrics extends Equatable {
  final List<BuildResult> buildResults;

  @override
  List<Object> get props => [buildResults];

  /// Creates the [BuildResultMetrics].
  ///
  /// [buildResults] represents the results of several builds.
  const BuildResultMetrics({this.buildResults = const []});
}
