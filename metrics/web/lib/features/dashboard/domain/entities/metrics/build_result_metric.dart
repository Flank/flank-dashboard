import 'package:meta/meta.dart';
import 'package:metrics/features/dashboard/domain/entities/metrics/build_result.dart';

/// Represents the build results metric entity.
@immutable
class BuildResultMetric {
  final List<BuildResult> buildResults;

  /// Creates the [BuildResultMetric].
  ///
  /// [buildResults] represents the results of several builds.
  const BuildResultMetric({this.buildResults = const []});
}
