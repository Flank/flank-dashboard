// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/ci/config/model/sync_config.dart';
import 'package:test/test.dart';

void main() {
  group("SyncConfig", () {
    const sourceProjectId = 'test2';
    const destinationProjectId = 'test';
    const initialSyncLimit = 10;
    const coverage = false;

    test(
      "throws an ArgumentError if the given source project id is null",
      () {
        expect(
          () => SyncConfig(
            sourceProjectId: null,
            destinationProjectId: destinationProjectId,
            initialSyncLimit: initialSyncLimit,
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
            initialSyncLimit: initialSyncLimit,
            coverage: coverage,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given initial sync limit is null",
      () {
        expect(
          () => SyncConfig(
            sourceProjectId: sourceProjectId,
            destinationProjectId: destinationProjectId,
            initialSyncLimit: null,
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
            initialSyncLimit: initialSyncLimit,
            coverage: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given initial sync limit is 0",
      () {
        expect(
          () => SyncConfig(
            sourceProjectId: sourceProjectId,
            destinationProjectId: destinationProjectId,
            initialSyncLimit: 0,
            coverage: coverage,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given initial sync limit is a negative number",
      () {
        expect(
          () => SyncConfig(
            sourceProjectId: sourceProjectId,
            destinationProjectId: destinationProjectId,
            initialSyncLimit: -1,
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
          initialSyncLimit: initialSyncLimit,
          coverage: coverage,
        );

        expect(syncConfig.sourceProjectId, equals(sourceProjectId));
        expect(syncConfig.destinationProjectId, equals(destinationProjectId));
        expect(syncConfig.initialSyncLimit, equals(initialSyncLimit));
        expect(syncConfig.coverage, equals(coverage));
      },
    );
  });
}
