// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

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
  /// Does nothing if a project with the given [projectId] is not found.
  Future<void> addBuilds(String projectId, List<BuildData> builds);
}
