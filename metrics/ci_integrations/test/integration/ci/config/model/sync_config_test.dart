import 'package:ci_integration/integration/ci/config/model/sync_config.dart';
import 'package:test/test.dart';

void main() {
  group("SyncConfig", () {
    test(
      "throws an ArgumentError if the given source project id is null",
      () {
        expect(
          () => SyncConfig(
            sourceProjectId: null,
            destinationProjectId: 'test',
            coverage: false,
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
            sourceProjectId: 'test',
            destinationProjectId: null,
            coverage: false,
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
            sourceProjectId: 'test',
            destinationProjectId: 'test',
            coverage: null,
          ),
          throwsArgumentError,
        );
      },
    );
  });
}
