import 'package:ci_integration/cli/logger/mixin/logger_mixin.dart';
import 'package:ci_integration/integration/ci/config/model/sync_config.dart';
import 'package:ci_integration/integration/interface/destination/client/destination_client.dart';
import 'package:ci_integration/integration/interface/source/client/source_client.dart';
import 'package:ci_integration/util/model/interaction_result.dart';
import 'package:meta/meta.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class providing a synchronization algorithm for a project's builds
/// performed on a CI tool and stored in a builds storage.
class CiIntegration with LoggerMixin {
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
  /// Throws an [ArgumentError] if the given [config] is `null`.
  Future<InteractionResult> sync(
    SyncConfig config,
  ) async {
    ArgumentError.checkNotNull(config);

    try {
      final sourceProjectId = config.sourceProjectId;
      final destinationProjectId = config.destinationProjectId;

      final lastBuild = await destinationClient.fetchLastBuild(
        destinationProjectId,
      );

      List<BuildData> newBuilds;
      if (lastBuild == null) {
        logger.info('There are no builds in the destination...');
        final initialSyncLimit = config.initialSyncLimit;
        newBuilds = await sourceClient.fetchBuilds(
          sourceProjectId,
          initialSyncLimit,
        );
      } else {
        newBuilds = await sourceClient.fetchBuildsAfter(
          sourceProjectId,
          lastBuild,
        );
      }

      if (newBuilds == null || newBuilds.isEmpty) {
        return const InteractionResult.success(
          message: 'The project data is up-to-date!',
        );
      }

      if (config.coverage) {
        newBuilds = await _fetchCoverage(newBuilds);
      }

      await destinationClient.addBuilds(
        destinationProjectId,
        newBuilds,
      );

      return const InteractionResult.success(
        message: 'The data has been synced successfully!',
      );
    } catch (error) {
      return InteractionResult.error(
        message: 'Failed to sync the data! Details: $error',
      );
    }
  }

  /// Fetches coverage data for each build in the given [builds] list.
  Future<List<BuildData>> _fetchCoverage(List<BuildData> builds) async {
    logger.info('Fetching coverage data for builds...');
    final fetchCoverageFutures = builds.map((build) async {
      final coverage = await sourceClient.fetchCoverage(build);

      return build.copyWith(coverage: coverage);
    });

    return Future.wait(fetchCoverageFutures);
  }
}
