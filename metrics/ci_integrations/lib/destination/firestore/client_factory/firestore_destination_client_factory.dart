// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/cli/logger/mixin/logger_mixin.dart';
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
    with
        LoggerMixin
    implements
        DestinationClientFactory<FirestoreDestinationConfig,
            FirestoreDestinationClientAdapter> {
  /// The [FirebaseAuth] instance used to authenticate the Firestore client.
  final FirebaseAuth _firebaseAuth;

  /// Creates an instance of this client factory.
  ///
  /// If the [_firebaseAuth] is `null`, then the [FirebaseAuth.initialize]
  /// is used to create authentication.
  const FirestoreDestinationClientFactory([this._firebaseAuth]);

  @override
  Future<FirestoreDestinationClientAdapter> create(
    FirestoreDestinationConfig config,
  ) async {
    ArgumentError.checkNotNull(config, 'config');

    final auth = _firebaseAuth ??
        FirebaseAuth.initialize(
          config.firebasePublicApiKey,
          VolatileStore(),
        );

    logger.info('Signing in to the Firebase...');
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
