// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/ci/sync_stage/sync_stage.dart';
import 'package:metrics_core/metrics_core.dart';

/// An abstract class that represents a [SyncStage] for builds.
abstract class BuildsSyncStage implements SyncStage {
  /// Returns a [List] of [BuildData] with the fetched coverage data for the 
  /// given list of [builds].
  Future<List<BuildData>> addCoverageData(List<BuildData> builds) async {
    List<BuildData> result;

    for (final build in builds) {
      final coverage = await sourceClient.fetchCoverage(build);
      final newBuild = build.copyWith(coverage: coverage);

      result.add(newBuild);
    }

    return result;
  }
}
