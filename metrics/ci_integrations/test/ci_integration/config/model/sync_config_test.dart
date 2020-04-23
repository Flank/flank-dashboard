import 'package:ci_integration/ci_integration/config/model/sync_config.dart';
import 'package:test/test.dart';

void main() {
  group("SyncConfig", () {
    test(
      "should throw an ArgumentError trying to create an instance with no sourceProjectId",
      () {
        expect(
          () => SyncConfig(
            sourceProjectId: null,
            destinationProjectId: 'test',
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "should throw an ArgumentError trying to create an instance with no destinationProjectId",
      () {
        expect(
          () => SyncConfig(
            sourceProjectId: 'test',
            destinationProjectId: null,
          ),
          throwsArgumentError,
        );
      },
    );
  });
}
