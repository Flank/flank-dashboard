import 'package:ci_integration/integration/ci_integration/ci_integration.dart';
import 'package:ci_integration/integration/interface/base/client/integration_client.dart';
import 'package:metrics_core/metrics_core.dart';

/// An abstract class providing a contract of interactions between
/// [CiIntegration] and source API.
abstract class SourceClient extends IntegrationClient {
  /// Fetches a list of builds for a project, identified by [projectId],
  /// which have been performed after the given [build].
  ///
  /// Returns `null` if a project with the given [projectId] is not found.
  Future<List<BuildData>> fetchBuildsAfter(String projectId, BuildData build);

  /// Fetches a list with all builds for a project, identified by [projectId].
  ///
  /// Returns `null` if a project with the given [projectId] is not found.
  Future<List<BuildData>> fetchBuilds(String projectId);
}
