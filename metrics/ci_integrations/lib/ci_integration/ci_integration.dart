import 'package:ci_integration/ci_integration/config/model/sync_config.dart';
import 'package:ci_integration/common/client/destination_client.dart';
import 'package:ci_integration/common/client/source_client.dart';
import 'package:ci_integration/common/model/interaction_result.dart';
import 'package:meta/meta.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class providing a synchronization algorithm for a project's builds
/// performed on a CI tool and stored in a builds storage.
class CiIntegration {
  /// Used to interact with a source API.
  final SourceClient sourceClient;

  /// Used to interact with a builds storage.
  final DestinationClient destinationClient;

  /// Creates a [CiIntegration] instance with the given [sourceClient]
  /// and [destinationClient].
  ///
  /// Both clients are required. Throws [ArgumentError] if either
  /// [sourceClient] or [destinationClient] is `null`.
  CiIntegration({
    @required this.sourceClient,
    @required this.destinationClient,
  }) {
    ArgumentError.checkNotNull(sourceClient, 'sourceClient');
    ArgumentError.checkNotNull(destinationClient, 'destinationClient');
  }

  /// Synchronizes builds for a project specified in the given [config].
  ///
  /// If [config] is `null` throws the [ArgumentError].
  Future<InteractionResult> sync(SyncConfig config) async {
    ArgumentError.checkNotNull(config);

    try {
      final sourceProjectId = config.sourceProjectId;
      final destinationProjectId = config.destinationProjectId;

      final lastBuild = await destinationClient.fetchLastBuild(
        destinationProjectId,
      );

      List<BuildData> newBuilds;
      if (lastBuild == null) {
        newBuilds = await sourceClient.fetchBuilds(sourceProjectId);
      } else {
        newBuilds = await sourceClient.fetchBuildsAfter(
          sourceProjectId,
          lastBuild,
        );
      }

      if (newBuilds != null && newBuilds.isNotEmpty) {
        await destinationClient.addBuilds(
          destinationProjectId,
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
