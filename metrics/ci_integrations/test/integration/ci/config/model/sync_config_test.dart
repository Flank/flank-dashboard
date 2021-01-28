import 'package:ci_integration/integration/ci/config/model/sync_config.dart';
import 'package:test/test.dart';

void main() {
  group("SyncConfig", () {
    const sourceProjectId = 'test2';
    const destinationProjectId = 'test';
    const firstSyncFetchLimit = 10;
    const coverage = false;

    test(
      "throws an ArgumentError if the given source project id is null",
      () {
        expect(
          () => SyncConfig(
            sourceProjectId: null,
            destinationProjectId: destinationProjectId,
            firstSyncFetchLimit: firstSyncFetchLimit,
            coverage: coverage,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given destination project id is null",
      () {
        expect(
          () => SyncConfig(
            sourceProjectId: sourceProjectId,
            destinationProjectId: null,
            firstSyncFetchLimit: firstSyncFetchLimit,
            coverage: coverage,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given first sync fetch limit is null",
      () {
        expect(
          () => SyncConfig(
            sourceProjectId: sourceProjectId,
            destinationProjectId: destinationProjectId,
            firstSyncFetchLimit: null,
            coverage: coverage,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given coverage is null",
      () {
        expect(
          () => SyncConfig(
            sourceProjectId: sourceProjectId,
            destinationProjectId: destinationProjectId,
            firstSyncFetchLimit: firstSyncFetchLimit,
            coverage: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given first sync fetch limit is 0",
      () {
        expect(
          () => SyncConfig(
            sourceProjectId: sourceProjectId,
            destinationProjectId: destinationProjectId,
            firstSyncFetchLimit: 0,
            coverage: coverage,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given first sync fetch limit is a negative number",
      () {
        expect(
          () => SyncConfig(
            sourceProjectId: sourceProjectId,
            destinationProjectId: destinationProjectId,
            firstSyncFetchLimit: -1,
            coverage: coverage,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        final syncConfig = SyncConfig(
          sourceProjectId: sourceProjectId,
          destinationProjectId: destinationProjectId,
          firstSyncFetchLimit: firstSyncFetchLimit,
          coverage: coverage,
        );

        expect(syncConfig.sourceProjectId, equals(sourceProjectId));
        expect(syncConfig.destinationProjectId, equals(destinationProjectId));
        expect(syncConfig.firstSyncFetchLimit, equals(firstSyncFetchLimit));
        expect(syncConfig.coverage, equals(coverage));
      },
    );
  });
}
