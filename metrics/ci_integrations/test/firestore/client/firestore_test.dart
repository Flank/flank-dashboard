import 'package:ci_integration/firestore/client/firestore.dart';
import 'package:firedart/firedart.dart' as fd;
import 'package:test/test.dart';

void main() {
  group("Firestore", () {
    const projectId = 'projectId';
    const apiKey = 'apiKey';

    test(
      "should throw an ArgumentError trying to create an instance with null project id",
      () {
        expect(() => Firestore(null), throwsArgumentError);
      },
    );

    test(
      "should throw an ArgumentError trying to create an instance with empty project id",
      () {
        expect(() => Firestore(''), throwsArgumentError);
      },
    );

    test("should create an instance with the given project id", () {
      final result = Firestore(projectId);

      expect(result.projectId, equals(projectId));
    });

    test(
      "should create an instance with the given firebase authentication",
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
