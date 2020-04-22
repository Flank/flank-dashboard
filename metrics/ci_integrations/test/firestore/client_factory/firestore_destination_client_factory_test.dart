import 'package:ci_integration/firestore/adapter/firestore_destination_client_adapter.dart';
import 'package:ci_integration/firestore/client_factory/firestore_destination_client_factory.dart';
import 'package:ci_integration/firestore/config/model/firestore_config.dart';
import 'package:firedart/firedart.dart';
import 'package:test/test.dart';

void main() {
  group("FirestoreDestinationClientFactory", () {
    const metricsProjectId = 'id';
    const firestoreProjectId = 'idasdasdsadsa';
    const firestoreDestinationClientFactory =
        FirestoreDestinationClientFactory();
    test(
        ".create() should throws ArgumentError if the given FirestoreConfig is null",
        () {
      expect(() => firestoreDestinationClientFactory.create(null),
          throwsArgumentError);
    });

    test(
        ".create() should create FirestoreDestinationClientAdapter instance from the given FirestoreConfig",
        () {
      final firestoreConfig = FirestoreConfig(
        metricsProjectId: metricsProjectId,
        firebaseProjectId: firestoreProjectId,
      );
      final result = firestoreDestinationClientFactory.create(firestoreConfig);
      expect(
        result,
        isA<FirestoreDestinationClientAdapter>(),
      );
    });
  });
}
