import 'package:ci_integration/common/config/ci_config.dart';
import 'package:ci_integration/common/client/ci_client.dart';
import 'package:ci_integration/common/client/storage_client.dart';
import 'package:ci_integration/common/model/interaction_result.dart';
import 'package:meta/meta.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class providing a synchronization algorithm for a project's builds
/// performed on a CI tool and stored in a builds storage.
class CiIntegration {
  /// Used to interact with a CI tool's API.
  final CiClient ciClient;

  /// Used to interact with a builds storage.
  final StorageClient storageClient;

  /// Creates a [CiIntegration] instance with the given [ciClient]
  /// and [storageClient].
  ///
  /// Both client are required. Throws [ArgumentError] if either
  /// [ciClient] or [storageClient] is `null`.
  CiIntegration({
    @required this.ciClient,
    @required this.storageClient,
  }) {
    ArgumentError.checkNotNull(ciClient, 'ciClient');
    ArgumentError.checkNotNull(storageClient, 'storageClient');
  }

  /// Synchronizes builds for a project specified in the given [config].
  Future<InteractionResult> sync(CiConfig config) async {
    try {
      final ciProjectId = config.ciProjectId;
      final storageProjectId = config.storageProjectId;

      final lastBuild = await storageClient.fetchLastBuild(storageProjectId);

      List<BuildData> newBuilds;
      if (lastBuild == null) {
        newBuilds = await ciClient.fetchBuilds(ciProjectId);
      } else {
        newBuilds = await ciClient.fetchBuildsAfter(ciProjectId, lastBuild);
      }

      if (newBuilds != null && newBuilds.isNotEmpty) {
        await storageClient.addBuilds(storageProjectId, newBuilds);
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
