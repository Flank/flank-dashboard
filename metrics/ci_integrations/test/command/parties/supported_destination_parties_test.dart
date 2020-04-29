import 'package:ci_integration/command/parties/supported_destination_parties.dart';
import 'package:ci_integration/destination/firestore/party/firestore_destination_party.dart';
import 'package:test/test.dart';

void main() {
  group("SupportedDestinationParties", () {
    final supportedDestinationParties = SupportedDestinationParties();

    test(".parties should contain the Firestore destination party", () {
      final parties = supportedDestinationParties.parties;

      expect(parties, contains(isA<FirestoreDestinationParty>()));
    });

    test(".parties should be an unmodifiable list", () {
      final parties = supportedDestinationParties.parties;

      expect(() => parties.add(null), throwsUnsupportedError);
      expect(() => parties.removeAt(0), throwsUnsupportedError);
    });
  });
}
