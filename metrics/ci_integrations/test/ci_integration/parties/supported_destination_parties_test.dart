import 'package:ci_integration/ci_integration/parties/supported_destination_parties.dart';
import 'package:ci_integration/firestore/party/firestore_destination_party.dart';
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
