import 'package:metrics_core/metrics_core.dart';

/// An abstract class providing methods for interactions between
/// [Synchronizer] and Firestore database.
abstract class FirestoreInteractor {
  /// Fetches the last build for a project specified by [projectId].
  Future<BuildData> fetchLastBuild(String projectId);

  /// Adds new [builds] to a project specified by [projectId].
  Future<void> addBuilds(String projectId, List<BuildData> builds);
}
