import 'package:ci_integration/client/firestore/firestore.dart' as fs;
import 'package:ci_integration/destination/firestore/adapter/firestore_destination_client_adapter.dart';
import 'package:ci_integration/destination/firestore/config/model/firestore_destination_config.dart';
import 'package:ci_integration/integration/interface/destination/client_factory/destination_client_factory.dart';
import 'package:firedart/firedart.dart';

/// A client factory for the Firestore destination integration.
///
/// Used to create instances of the [FirestoreDestinationClientAdapter]
/// using [FirestoreDestinationConfig].
class FirestoreDestinationClientFactory
    implements
        DestinationClientFactory<FirestoreDestinationConfig,
            FirestoreDestinationClientAdapter> {
  /// The [FirebaseAuth] instance used to authenticate the Firestore client.
  /// 
  /// If this is `null` then the [FirebaseAuth.initialize] is used.
  final FirebaseAuth _firebaseAuth;

  const FirestoreDestinationClientFactory([this._firebaseAuth]);

  @override
  Future<FirestoreDestinationClientAdapter> create(
    FirestoreDestinationConfig config,
  ) async {
    ArgumentError.checkNotNull(config, 'config');

    final auth = _firebaseAuth ??
        FirebaseAuth.initialize(
          config.firebaseWebApiKey,
          VolatileStore(),
        );

    await auth.signIn(
      config.firebaseUserEmail,
      config.firebaseUserPassword,
    );

    final firestore = fs.Firestore(
      config.firebaseProjectId,
      firebaseAuth: auth,
    );
    return FirestoreDestinationClientAdapter(firestore);
  }
}
