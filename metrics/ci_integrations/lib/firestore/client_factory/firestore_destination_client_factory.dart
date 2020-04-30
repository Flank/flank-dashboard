import 'package:ci_integration/common/client_factory/destination_client_factory.dart';
import 'package:ci_integration/firestore/adapter/firestore_destination_client_adapter.dart';
import 'package:ci_integration/firestore/client/firestore.dart';
import 'package:ci_integration/firestore/config/model/firestore_destination_config.dart';

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
