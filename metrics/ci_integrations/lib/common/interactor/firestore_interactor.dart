import 'package:metrics_core/metrics_core.dart';

/// An abstract class providing a methods for interactions between
/// [Synchronizer] and Firestore database.
abstract class FirestoreInteractor {
  /// Fetches the last build for a project specified by [projectIdentifier].
  Future<BuildData> fetchLastBuild(String projectIdentifier);

  /// Adds new [builds] to a project specified by [projectIdentifier].
  Future<void> addBuilds(String projectIdentifier, List<BuildData> builds);
}
