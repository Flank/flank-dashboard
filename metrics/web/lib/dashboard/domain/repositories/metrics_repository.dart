import 'package:metrics_core/metrics_core.dart';

/// Base class for metrics repositories.
///
/// Provides an ability to get the metrics data.
abstract class MetricsRepository {
  /// Provides the stream of [Build]s of the project with [projectId]
  /// where elements are ordered by [Build.startedAt]
  /// and only last [limit] elements returned.
  Stream<List<Build>> latestProjectBuildsStream(String projectId, int limit);

  /// Provides the stream of [Build]s of the project with [projectId] starting [from] date.
  Stream<List<Build>> projectBuildsFromDateStream(
    String projectId,
    DateTime from,
  );

  /// Provides the stream of the last successful [Build] of the project with [projectId].
  Stream<List<Build>> lastSuccessfulBuildStream(String projectId);
}
