// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/destination/firestore/factory/firestore_factory.dart';
import 'package:test/test.dart';
import 'package:firedart/firedart.dart';

void main() {
  group("FirestoreFactory", () {
    const firebaseProjectId = 'firebaseProjectId';
    const firestoreFactory = FirestoreFactory();
    final firebaseAuth = FirebaseAuth('key', VolatileStore());

    test(
      ".create() throws an ArgumentError if the given firebase project id is null",
      () {
        expect(
          () => firestoreFactory.create(
            null,
            firebaseAuth,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      ".create() throws an ArgumentError if the given firebase auth is null",
      () {
        expect(
          () => firestoreFactory.create(
            firebaseProjectId,
            null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      ".create() returns a new firestore instance with the given parameters",
      () {
        final firestore = firestoreFactory.create(
          firebaseProjectId,
          firebaseAuth,
        );

        expect(firestore.projectId, equals(firebaseProjectId));
        expect(firestore.firebaseAuth, equals(firebaseAuth));
      },
    );
  });
}
