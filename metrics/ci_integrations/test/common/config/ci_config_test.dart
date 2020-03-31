import 'package:ci_integration/common/config/ci_config.dart';
import 'package:test/test.dart';

void main() {
  group('CiConfig', () {
    const ciProjectId = 'ciProjectId';
    const storageProjectId = 'storageProjectId';

    test(
      "shoud throw ArgumentError trying to create an instance with null ciProjectId",
      () {
        expect(
          () => CiConfig(
            ciProjectId: null,
            storageProjectId: storageProjectId,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "shoud throw Argument error trying to create an instance with null storageProjectId",
      () {
        expect(
          () => CiConfig(
            ciProjectId: ciProjectId,
            storageProjectId: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "shoud throw ArgumentError trying to create an instance with null storageProjectId",
      () {
        expect(
          () => CiConfig(
            ciProjectId: ciProjectId,
            storageProjectId: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "should create insctance with the given project CI and storage id",
      () {
        final config = CiConfig(
          ciProjectId: ciProjectId,
          storageProjectId: storageProjectId,
        );

        expect(config.ciProjectId, equals(ciProjectId));
        expect(config.storageProjectId, equals(storageProjectId));
      },
    );
  });
}
