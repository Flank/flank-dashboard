// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics_core/metrics_core.dart';

/// A base class for metrics repositories.
///
/// Provides an ability to get the metrics data.
abstract class MetricsRepository {
  /// Provides the stream of [Build]s of the project with [projectId]
  /// where elements are ordered by [Build.startedAt]
  /// and only last [limit] elements returned.
  Stream<List<Build>> latestProjectBuildsStream(String projectId, int limit);

  /// Provides the stream of the last successful [Build] of the project with [projectId].
  Stream<List<Build>> lastSuccessfulBuildStream(String projectId);
}
