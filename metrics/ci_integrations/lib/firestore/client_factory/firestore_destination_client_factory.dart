import 'package:ci_integration/common/client_factory/destination_client_factory.dart';
import 'package:ci_integration/firestore/adapter/firestore_destination_client_adapter.dart';
import 'package:ci_integration/firestore/client/firestore.dart';
import 'package:ci_integration/firestore/config/model/firestore_config.dart';

/// A client factory for the Firestore destination integration.
///
/// Used to create instances of the [FirestoreDestinationClientAdapter]
/// using [FirestoreConfig].
class FirestoreDestinationClientFactory
    implements
        DestinationClientFactory<FirestoreConfig,
            FirestoreDestinationClientAdapter> {
  const FirestoreDestinationClientFactory();

  @override
  FirestoreDestinationClientAdapter create(FirestoreConfig config) {
    ArgumentError.checkNotNull(config, 'config');

    final firestore = Firestore(config.firebaseProjectId);
    return FirestoreDestinationClientAdapter(firestore);
  }
}
