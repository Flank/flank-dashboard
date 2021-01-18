import 'package:ci_integration/cli/logger/logger.dart';
import 'package:ci_integration/integration/ci/config/model/sync_config.dart';
import 'package:ci_integration/integration/interface/destination/client/destination_client.dart';
import 'package:ci_integration/integration/interface/source/client/source_client.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
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
        Logger.logInfo("There are no builds in Firestore...");
        newBuilds = await sourceClient.fetchBuilds(sourceProjectId);
      } else {
        Logger.logInfo("Fetching builds after build #${lastBuild.id}");
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
          message: 'The data has been synced successfully!',
        );
      } else {
        return const InteractionResult.success(
          message: 'The project data is up-to-date!',
        );
      }
    } catch (error) {
      return InteractionResult.error(
        message: 'Failed to sync the data! Details: $error',
      );
    }
  }
}
