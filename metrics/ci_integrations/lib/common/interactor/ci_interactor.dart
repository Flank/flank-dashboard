import 'package:ci_integration/common/synchronizer/synchronizer.dart';
import 'package:metrics_core/metrics_core.dart';

/// An abstract class providing a contract of interactions between
/// [Synchronizer] and CI tool's API.
abstract class CiInteractor {
  /// Fetches a list of builds for a project, identified by [projectId],
  /// which have been performed after the given [build].
  Future<List<BuildData>> fetchBuildsAfter(String projectId, BuildData build);
}
