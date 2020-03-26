import 'package:ci_integration/common/ci_integration/ci_integration.dart';
import 'package:metrics_core/metrics_core.dart';

/// An abstract class providing methods for interactions between
/// [CiIntegration] and database.
abstract class StorageClient {
  /// Fetches the last build for a project specified by [projectId].
  Future<BuildData> fetchLastBuild(String projectId);

  /// Adds new [builds] to a project specified by [projectId].
  Future<void> addBuilds(String projectId, List<BuildData> builds);
}
