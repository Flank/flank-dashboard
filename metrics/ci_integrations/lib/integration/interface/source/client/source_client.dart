// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/ci/ci_integration.dart';
import 'package:ci_integration/integration/interface/base/client/integration_client.dart';
import 'package:metrics_core/metrics_core.dart';

/// An abstract class providing a contract of interactions between
/// [CiIntegration] and source API.
abstract class SourceClient extends IntegrationClient {
  /// Fetches a list of builds for a project, identified by [projectId],
  /// which have been performed after the given [build].
  ///
  /// Returns an empty [List] if there are no new builds after the given [build].
  ///
  /// Throws an [ArgumentError] if the given [build] is null.
  /// Throws a [StateError] if fetching builds after the given [build] fails.
  Future<List<BuildData>> fetchBuildsAfter(String projectId, BuildData build);

  /// Fetches no more than [fetchLimit] number of builds for a project,
  /// identified by [projectId].
  ///
  /// Returns an empty [List] if there are no builds.
  ///
  /// Throws a [StateError] if fetching builds fails.
  Future<List<BuildData>> fetchBuilds(
    String projectId,
    int fetchLimit,
  );

  /// Fetches coverage data for the given [build].
  ///
  /// Returns `null` if a coverage artifact for the given [build]
  /// is not found.
  ///
  /// Throws an [ArgumentError] if the given [build] is `null`.
  /// Throws a [StateError] if coverage artifact fetching fails.
  Future<Percent> fetchCoverage(BuildData build);

  /// Fetches a build with the given [buildNumber] for the project identified
  /// by the given [projectId].
  ///
  /// Throws an [ArgumentError] is the given [projectId] or [buildNumber]
  /// is `null`.
  /// Throws a [StateError] if fetching the build fails.
  Future<BuildData> fetchOneBuild(String projectId, int buildNumber);
}
