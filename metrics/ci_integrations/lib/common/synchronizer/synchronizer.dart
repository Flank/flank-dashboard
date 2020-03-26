import 'package:ci_integration/common/config/ci_config.dart';
import 'package:ci_integration/common/interactor/ci_interactor.dart';
import 'package:ci_integration/common/interactor/firestore_interactor.dart';
import 'package:ci_integration/common/synchronizer/synchronization_result.dart';
import 'package:meta/meta.dart';

/// A class providing a synchronization algorithm for a project's builds
/// performed on a CI tool and stored on the Firestore database.
class Synchronizer {
  /// Used to interact with a CI tool's API.
  final CiInteractor ciInteractor;

  /// Used to interact with a Firestore database.
  final FirestoreInteractor firestoreInteractor;

  /// Creates a [Synchronizer] instance with the given [ciInteractor]
  /// and [firestoreInteractor].
  ///
  /// Both interactors are required. Throws [ArgumentError] if either
  /// [ciInteractor] or [firestoreInteractor] is `null`.
  Synchronizer({
    @required this.ciInteractor,
    @required this.firestoreInteractor,
  }) {
    ArgumentError.checkNotNull(ciInteractor, 'ciInteractor');
    ArgumentError.checkNotNull(firestoreInteractor, 'firestoreInteractor');
  }

  /// Synchronizes builds for a project specified in the given [config].
  Future<SynchronizationResult> sync(CiConfig config) async {
    try {
      final ciProjectIdentifier = config.ciProjectIdentifier;
      final firestoreProjectIdentifier = config.firestoreProjectIdentifier;

      final lastBuild = await firestoreInteractor.fetchLastBuild(
        firestoreProjectIdentifier,
      );
      final newBuilds = await ciInteractor.fetchBuildsAfter(
        ciProjectIdentifier,
        lastBuild,
      );

      if (newBuilds != null && newBuilds.isNotEmpty) {
        await firestoreInteractor.addBuilds(
          firestoreProjectIdentifier,
          newBuilds,
        );
        return const SynchronizationResult.success(
          message: 'The project has been updated successfully!',
        );
      } else {
        return const SynchronizationResult.success(
          message: 'The project is up-to-date!',
        );
      }
    } catch (error) {
      return SynchronizationResult.error(
        message: 'Failed to update the project! Details: $error',
      );
    }
  }
}
