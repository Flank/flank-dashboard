import 'package:ci_integration/firestore/client_factory/firestore_destination_client_factory.dart';
import 'package:ci_integration/firestore/config/parser/firestore_config_parser.dart';
import 'package:ci_integration/firestore/party/firestore_destination_party.dart';
import 'package:test/test.dart';

void main() {
  group("FirestoreDestinationParty", () {
    final firestoreDestinationParty = FirestoreDestinationParty();

    test("should use FirestoreDestinationClientFactory as a client factory", () {
      final clientFactory = firestoreDestinationParty.clientFactory;

      expect(clientFactory, isA<FirestoreDestinationClientFactory>());
    });

    test("should use FirestoreConfigParser as a config parser", () {
      final configParser = firestoreDestinationParty.configParser;

      expect(configParser, isA<FirestoreConfigParser>());
    });
  });
}
