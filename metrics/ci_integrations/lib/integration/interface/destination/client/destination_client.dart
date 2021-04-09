// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/destination/error/destination_error.dart';
import 'package:ci_integration/integration/ci/ci_integration.dart';
import 'package:ci_integration/integration/interface/base/client/integration_client.dart';
import 'package:metrics_core/metrics_core.dart';

/// An abstract class providing methods for interactions between
/// [CiIntegration] and destination storage.
abstract class DestinationClient extends IntegrationClient {
  /// Fetches the last build for a project specified by [projectId].
  ///
  /// Returns `null` if either a project with the given [projectId]
  /// is not found or there are no builds for a project.
  Future<BuildData> fetchLastBuild(String projectId);

  /// Adds new [builds] to a project specified by [projectId].
  ///
  /// Throws an [ArgumentError] if the project with the given [projectId]
  /// does not exist.
  /// Throws a [DestinationError] if adding the given [builds] fails.
  Future<void> addBuilds(String projectId, List<BuildData> builds);

  /// Fetches a list of builds with the given [status] for a project identified
  /// by the given [projectId].
  ///
  /// Returns an empty [List] if there are no builds with the given [status].
  ///
  /// Throws an [ArgumentError] if the given [projectId] or [status] is `null`.
  /// Throws an [ArgumentError] if the project with the given [projectId]
  /// does not exist.
  /// Throws a [DestinationError] if fetching builds with the
  /// given [status] fails.
  Future<List<BuildData>> fetchBuildsWithStatus(
    String projectId,
    BuildStatus status,
  );

  /// Updates the builds of the project identified by the given [projectId]
  /// with the given [builds].
  ///
  /// Throws an [ArgumentError] if the given [projectId] or [builds] is `null`.
  /// Throws an [ArgumentError] if a project with the given [projectId]
  /// does not exist.
  /// Throws a [DestinationError] if updating [builds] fails.
  Future<void> updateBuilds(String projectId, List<BuildData> builds);
}
