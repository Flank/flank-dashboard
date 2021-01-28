import 'package:ci_integration/integration/ci/config/model/sync_config.dart';
import 'package:test/test.dart';

void main() {
  group("SyncConfig", () {
    const sourceProjectId = 'test2';
    const destinationProjectId = 'test';
    const initialFetchLimit = 10;
    const coverage = false;

    test(
      "throws an ArgumentError if the given source project id is null",
      () {
        expect(
          () => SyncConfig(
            sourceProjectId: null,
            destinationProjectId: destinationProjectId,
            initialFetchLimit: initialFetchLimit,
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
            initialFetchLimit: initialFetchLimit,
            coverage: coverage,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given initial fetch limit is null",
      () {
        expect(
          () => SyncConfig(
            sourceProjectId: sourceProjectId,
            destinationProjectId: destinationProjectId,
            initialFetchLimit: null,
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
            initialFetchLimit: initialFetchLimit,
            coverage: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given initial fetch limit is 0",
      () {
        expect(
          () => SyncConfig(
            sourceProjectId: sourceProjectId,
            destinationProjectId: destinationProjectId,
            initialFetchLimit: 0,
            coverage: coverage,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given initial fetch limit is a negative number",
      () {
        expect(
          () => SyncConfig(
            sourceProjectId: sourceProjectId,
            destinationProjectId: destinationProjectId,
            initialFetchLimit: -1,
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
          initialFetchLimit: initialFetchLimit,
          coverage: coverage,
        );

        expect(syncConfig.sourceProjectId, equals(sourceProjectId));
        expect(syncConfig.destinationProjectId, equals(destinationProjectId));
        expect(syncConfig.initialFetchLimit, equals(initialFetchLimit));
        expect(syncConfig.coverage, equals(coverage));
      },
    );
  });
}
