import 'package:ci_integration/firestore/adapter/firestore_destination_client_adapter.dart';
import 'package:ci_integration/firestore/client_factory/firestore_destination_client_factory.dart';
import 'package:ci_integration/firestore/config/model/firestore_destination_config.dart';
import 'package:test/test.dart';

// ignore_for_file: prefer_const_constructors

void main() {
  group("FirestoreDestinationClientFactory", () {
    const firestoreProjectId = 'firestoreProjectId';
    final firestoreClientFactory = FirestoreDestinationClientFactory();

    FirestoreDestinationClientAdapter adapter;

    tearDown(() {
      adapter?.dispose();
    });

    test(
      ".create() should throw an ArgumentError if the given FirestoreConfig is null",
      () {
        expect(
          () => firestoreClientFactory.create(null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".create() should create a FirestoreDestinationClientAdapter instance from the given FirestoreConfig",
      () {
        final firestoreConfig = FirestoreDestinationConfig(
          metricsProjectId: 'metricsProjectId',
          firebaseProjectId: firestoreProjectId,
        );

        adapter = firestoreClientFactory.create(firestoreConfig);

        expect(adapter, isA<FirestoreDestinationClientAdapter>());
      },
    );
  });
}
