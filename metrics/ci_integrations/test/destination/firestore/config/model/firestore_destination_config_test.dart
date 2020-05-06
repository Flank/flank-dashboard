import 'package:ci_integration/destination/firestore/config/model/firestore_destination_config.dart';
import 'package:test/test.dart';

import '../../test_utils/test_data/firestore_config_test_data.dart';

void main() {
  group("FirestoreDestinationConfig", () {
    final firestoreConfigJson = FirestoreConfigTestData.firestoreConfigJson;
    final firestoreConfig = FirestoreConfigTestData.firestoreConfig;

    test(
      "can't be created when the firebaseProjectId is null",
      () {
        expect(
          () => FirestoreDestinationConfig(
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
          () => FirestoreDestinationConfig(
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
        final config = FirestoreDestinationConfig.fromJson(null);

        expect(config, isNull);
      },
    );

    test(
      '.fromJson() should create an instance of FirestoreConfig from JSON encodable Map',
      () {
        final parsed = FirestoreDestinationConfig.fromJson(firestoreConfigJson);

        expect(parsed, equals(firestoreConfig));
      },
    );
  });
}
