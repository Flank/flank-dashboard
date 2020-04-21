import 'package:ci_integration/ci_integration/config/model/sync_config.dart';
import 'package:test/test.dart';

void main() {
  group('SyncConfig', () {
    const ciProjectId = 'ciProjectId';
    const storageProjectId = 'storageProjectId';

    test(
      "shoud throw ArgumentError trying to create an instance with null ciProjectId",
      () {
        expect(
          () => SyncConfig(
            sourceProjectId: null,
            destinationProjectId: storageProjectId,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "shoud throw Argument error trying to create an instance with null storageProjectId",
      () {
        expect(
          () => SyncConfig(
            sourceProjectId: ciProjectId,
            destinationProjectId: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "should create insctance with the given project CI and storage id",
      () {
        final config = SyncConfig(
          sourceProjectId: ciProjectId,
          destinationProjectId: storageProjectId,
        );

        expect(config.sourceProjectId, equals(ciProjectId));
        expect(config.destinationProjectId, equals(storageProjectId));
      },
    );
  });
}
