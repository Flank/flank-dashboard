// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/cli/logger/mixin/logger_mixin.dart';
import 'package:ci_integration/integration/ci/sync_stage/sync_stage.dart';
import 'package:metrics_core/metrics_core.dart';

/// An abstract class that represents a [SyncStage] for builds.
abstract class BuildsSyncStage with LoggerMixin implements SyncStage {
  /// Returns a [List] of [BuildData] with the fetched coverage data for the
  /// given list of [builds].
  ///
  /// Returns an empty [List] if the given [builds] are `null` or empty.
  Future<List<BuildData>> addCoverageData(List<BuildData> builds) async {
    logger.info('Fetching coverage data for builds...');

    if (builds == null || builds.isEmpty) return const [];

    final buildsWithCoverageFutures = builds.map((build) async {
      final coverage = await sourceClient.fetchCoverage(build);
      final newBuild = build.copyWith(coverage: coverage);

      return build.copyWith(coverage: coverage);
    });

    return Future.wait(buildsWithCoverageFutures);
  }
}
