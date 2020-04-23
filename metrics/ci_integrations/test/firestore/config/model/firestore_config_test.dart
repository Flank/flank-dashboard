import 'package:ci_integration/firestore/config/model/firestore_config.dart';
import 'package:test/test.dart';

import '../../test_utils/firestore_config_test_data.dart';

void main() {
  group("FirestoreConfig", () {
    final firestoreConfigJson = FirestoreConfigTestData.firestoreConfigJson;
    final firestoreConfig = FirestoreConfigTestData.firestoreConfig;

    test(
      "can't be created when the firebaseProjectId is null",
      () {
        expect(
          () => FirestoreConfig(
            metricsProjectId: FirestoreConfigTestData.metricsProjectId,
            firebaseProjectId: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "can't be created when the metricsProjectId is null",
      () {
        expect(
          () => FirestoreConfig(
            firebaseProjectId: FirestoreConfigTestData.firebaseProjectId,
            metricsProjectId: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      ".fromJson() should return null if the given JSON map is null",
      () {
        final config = FirestoreConfig.fromJson(null);

        expect(config, isNull);
      },
    );

    test(
      '.fromJson() should create an instance of FirestoreConfig from JSON encodable Map',
      () {
        final parsed = FirestoreConfig.fromJson(firestoreConfigJson);

        expect(parsed, equals(firestoreConfig));
      },
    );
  });
}
