import 'package:ci_integration/ci_integration/ci_integration.dart';
import 'package:metrics_core/metrics_core.dart';

/// An abstract class providing a contract of interactions between
/// [CiIntegration] and CI tool's API.
abstract class CiClient {
  /// Fetches a list of builds for a project, identified by [projectId],
  /// which have been performed after the given [build].
  ///
  /// Returns `null` if a project with the given [projectId] is not found.
  /// Returns all builds if [build] is `null`.
  Future<List<BuildData>> fetchBuildsAfter(String projectId, BuildData build);
}
