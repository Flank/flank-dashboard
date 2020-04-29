import 'package:ci_integration/client/firestore/firestore.dart';
import 'package:firedart/firedart.dart' as fd;
import 'package:test/test.dart';

void main() {
  group("Firestore", () {
    const projectId = 'projectId';
    const apiKey = 'apiKey';

    test(
      "should throw an AssertionError trying to create an instance with empty project id",
      () {
        expect(() => Firestore(''), throwsA(isA<AssertionError>()));
      },
    );

    test("should create an instance with the given project id", () {
      final result = Firestore(projectId);

      expect(result.projectId, equals(projectId));
    });

    test(
      "should create an instance with the given Firebase authentication",
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
