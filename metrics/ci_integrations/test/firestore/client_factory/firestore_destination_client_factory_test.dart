import 'package:ci_integration/firestore/adapter/firestore_destination_client_adapter.dart';
import 'package:ci_integration/firestore/client_factory/firestore_destination_client_factory.dart';
import 'package:ci_integration/firestore/config/model/firestore_config.dart';
import 'package:test/test.dart';

// ignore_for_file: prefer_const_constructors

void main() {
  group("FirestoreDestinationClientFactory", () {
    const firestoreProjectId = 'firestoreProjectId';
    final firestoreClientFactory = FirestoreDestinationClientFactory();

    test(
      ".create() should throws ArgumentError if the given FirestoreConfig is null",
      () {
        expect(
          () => firestoreClientFactory.create(null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".create() should create FirestoreDestinationClientAdapter instance from the given FirestoreConfig",
      () {
        final firestoreConfig = FirestoreConfig(
          metricsProjectId: 'metricsProjectId',
          firebaseProjectId: firestoreProjectId,
        );

        final result = firestoreClientFactory.create(firestoreConfig);

        expect(result, isA<FirestoreDestinationClientAdapter>());
      },
    );
  });
}
