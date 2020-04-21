import 'dart:async';

import 'package:ci_integration/common/client_factory/destination_client_factory.dart';
import 'package:ci_integration/firestore/adapter/firestore_destination_client_adapter.dart';
import 'package:ci_integration/firestore/config/model/firestore_config.dart';
import 'package:firedart/firedart.dart';

class FirestoreDestinationClientFactory
    implements
        DestinationClientFactory<FirestoreConfig,
            FirestoreDestinationClientAdapter> {
  const FirestoreDestinationClientFactory();

  @override
  FutureOr<FirestoreDestinationClientAdapter> create(FirestoreConfig config) {
    final firestore = Firestore(config.firebaseProjectId);
    return FirestoreDestinationClientAdapter(firestore);
  }
}
