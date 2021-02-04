// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/firestore/firestore.dart';
import 'package:firedart/firedart.dart' as fd;
import 'package:test/test.dart';

void main() {
  group("Firestore", () {
    const projectId = 'projectId';
    const apiKey = 'apiKey';

    test(
      "throws an AssertionError if the given project id is empty",
      () {
        expect(() => Firestore(''), throwsA(isA<AssertionError>()));
      },
    );

    test("creates an instance with the given project id", () {
      final result = Firestore(projectId);

      expect(result.projectId, equals(projectId));
    });

    test(
      "creates an instance with the given Firebase authentication",
      () {
        final firebaseAuth = fd.FirebaseAuth(apiKey, fd.VolatileStore());

        final result = Firestore(
          projectId,
          firebaseAuth: firebaseAuth,
        );

        expect(result.firebaseAuth, equals(firebaseAuth));
      },
    );
  });
}
