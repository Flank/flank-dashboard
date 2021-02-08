// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/destination/firestore/config/model/firestore_destination_config.dart';
import 'package:test/test.dart';

import '../../test_utils/test_data/firestore_config_test_data.dart';

void main() {
  group("FirestoreDestinationConfig", () {
    const firestoreConfigJson =
        FirestoreConfigTestData.firestoreDestinationConfigMap;
    final firestoreConfig = FirestoreConfigTestData.firestoreDestiantionConfig;

    test(
      "throws an ArgumentError if the given metrics project id is null",
      () {
        expect(
          () => FirestoreDestinationConfig(
            metricsProjectId: null,
            firebaseProjectId: FirestoreConfigTestData.firebaseProjectId,
            firebaseUserEmail: FirestoreConfigTestData.firebaseUserEmail,
            firebaseUserPassword: FirestoreConfigTestData.firebaseUserPassword,
            firebasePublicApiKey: FirestoreConfigTestData.firebasePublicApiKey,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given firebase project id is null",
      () {
        expect(
          () => FirestoreDestinationConfig(
            metricsProjectId: FirestoreConfigTestData.metricsProjectId,
            firebaseProjectId: null,
            firebaseUserEmail: FirestoreConfigTestData.firebaseUserEmail,
            firebaseUserPassword: FirestoreConfigTestData.firebaseUserPassword,
            firebasePublicApiKey: FirestoreConfigTestData.firebasePublicApiKey,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given firebase user email is null",
      () {
        expect(
          () => FirestoreDestinationConfig(
            metricsProjectId: FirestoreConfigTestData.metricsProjectId,
            firebaseProjectId: FirestoreConfigTestData.firebaseProjectId,
            firebaseUserEmail: null,
            firebaseUserPassword: FirestoreConfigTestData.firebaseUserPassword,
            firebasePublicApiKey: FirestoreConfigTestData.firebasePublicApiKey,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given firebase user password is null",
      () {
        expect(
          () => FirestoreDestinationConfig(
            metricsProjectId: FirestoreConfigTestData.metricsProjectId,
            firebaseProjectId: FirestoreConfigTestData.firebaseProjectId,
            firebaseUserEmail: FirestoreConfigTestData.firebaseUserEmail,
            firebaseUserPassword: null,
            firebasePublicApiKey: FirestoreConfigTestData.firebasePublicApiKey,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given firebase public API key is null",
      () {
        expect(
          () => FirestoreDestinationConfig(
            metricsProjectId: FirestoreConfigTestData.metricsProjectId,
            firebaseProjectId: FirestoreConfigTestData.firebaseProjectId,
            firebaseUserEmail: FirestoreConfigTestData.firebaseUserEmail,
            firebaseUserPassword: FirestoreConfigTestData.firebaseUserPassword,
            firebasePublicApiKey: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      ".fromJson() returns null if the given JSON map is null",
      () {
        final config = FirestoreDestinationConfig.fromJson(null);

        expect(config, isNull);
      },
    );

    test(
      '.fromJson() creates an instance of FirestoreConfig from JSON encodable Map',
      () {
        final parsed = FirestoreDestinationConfig.fromJson(firestoreConfigJson);

        expect(parsed, equals(firestoreConfig));
      },
    );
  });
}
