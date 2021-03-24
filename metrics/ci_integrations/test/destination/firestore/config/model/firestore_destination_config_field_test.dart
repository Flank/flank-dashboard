// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:collection';

import 'package:ci_integration/destination/firestore/config/model/firestore_destination_config_field.dart';
import 'package:test/test.dart';

void main() {
  group("FirestoreDestinationConfigField", () {
    test(
      ".values is unmodifiable list view",
      () {
        expect(
          FirestoreDestinationConfigField.values,
          isA<UnmodifiableListView>(),
        );
      },
    );

    test(
      ".values contains all firestore source config fields",
      () {
        final expectedConfigFields = [
          FirestoreDestinationConfigField.firebaseProjectId,
          FirestoreDestinationConfigField.firebasePublicApiKey,
          FirestoreDestinationConfigField.firebaseUserPassword,
          FirestoreDestinationConfigField.firebaseUserEmail,
          FirestoreDestinationConfigField.metricsProjectId,
        ];

        expect(
          FirestoreDestinationConfigField.values,
          containsAll(expectedConfigFields),
        );
      },
    );
  });
}
