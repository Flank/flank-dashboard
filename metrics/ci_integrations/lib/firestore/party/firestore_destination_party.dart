import 'package:ci_integration/common/party/destination_party.dart';
import 'package:ci_integration/firestore/adapter/firestore_destination_client_adapter.dart';
import 'package:ci_integration/firestore/client_factory/firestore_destination_client_factory.dart';
import 'package:ci_integration/firestore/config/model/firestore_config.dart';
import 'package:ci_integration/firestore/config/parser/firestore_config_parser.dart';

/// An integration party for the Firestore destination integration.
class FirestoreDestinationParty
    implements
        DestinationParty<FirestoreConfig, FirestoreDestinationClientAdapter> {
  @override
  final FirestoreDestinationClientFactory clientFactory =
      const FirestoreDestinationClientFactory();

  @override
  final FirestoreConfigParser configParser = const FirestoreConfigParser();
}
