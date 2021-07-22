// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:collection';

import 'package:ci_integration/destination/firestore/config/model/firestore_destination_validation_target.dart';
import 'package:test/test.dart';

void main() {
  group("FirestoreDestinationValidationTarget", () {
    test(
      ".values is unmodifiable list view",
      () {
        expect(
          FirestoreDestinationValidationTarget.values,
          isA<UnmodifiableListView>(),
        );
      },
    );

    test(
      ".values contains all firestore source validation targets",
      () {
        final expectedValidationTargets = [
          FirestoreDestinationValidationTarget.firebaseProjectId,
          FirestoreDestinationValidationTarget.firebasePublicApiKey,
          FirestoreDestinationValidationTarget.firebaseUserPassword,
          FirestoreDestinationValidationTarget.firebaseUserEmail,
          FirestoreDestinationValidationTarget.metricsProjectId,
        ];

        expect(
          FirestoreDestinationValidationTarget.values,
          containsAll(expectedValidationTargets),
        );
      },
    );
  });
}
