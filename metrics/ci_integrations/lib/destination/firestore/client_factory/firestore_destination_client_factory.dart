import 'package:ci_integration/client/firestore/firestore.dart';
import 'package:ci_integration/destination/firestore/adapter/firestore_destination_client_adapter.dart';
import 'package:ci_integration/destination/firestore/config/model/firestore_destination_config.dart';
import 'package:ci_integration/integration/interface/destination/client_factory/destination_client_factory.dart';

/// A client factory for the Firestore destination integration.
///
/// Used to create instances of the [FirestoreDestinationClientAdapter]
/// using [FirestoreDestinationConfig].
class FirestoreDestinationClientFactory
    implements
        DestinationClientFactory<FirestoreDestinationConfig,
            FirestoreDestinationClientAdapter> {
  const FirestoreDestinationClientFactory();

  @override
  FirestoreDestinationClientAdapter create(FirestoreDestinationConfig config) {
    ArgumentError.checkNotNull(config, 'config');

    final firestore = Firestore(config.firebaseProjectId);
    return FirestoreDestinationClientAdapter(firestore);
  }
}
