import 'package:ci_integration/common/config/ci_config.dart';
import 'package:ci_integration/common/interactor/ci_interactor.dart';
import 'package:ci_integration/common/interactor/firestore_interactor.dart';
import 'package:ci_integration/common/model/interaction_result.dart';
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
  Future<InteractionResult> sync(CiConfig config) async {
    try {
      final ciProjectId = config.ciProjectId;
      final firestoreProjectId = config.firestoreProjectId;

      final lastBuild = await firestoreInteractor.fetchLastBuild(
        firestoreProjectId,
      );
      final newBuilds = await ciInteractor.fetchBuildsAfter(
        ciProjectId,
        lastBuild,
      );

      if (newBuilds != null && newBuilds.isNotEmpty) {
        await firestoreInteractor.addBuilds(
          firestoreProjectId,
          newBuilds,
        );
        return const InteractionResult.success(
          message: 'The project has been updated successfully!',
        );
      } else {
        return const InteractionResult.success(
          message: 'The project is up-to-date!',
        );
      }
    } catch (error) {
      return InteractionResult.error(
        message: 'Failed to update the project! Details: $error',
      );
    }
  }
}
