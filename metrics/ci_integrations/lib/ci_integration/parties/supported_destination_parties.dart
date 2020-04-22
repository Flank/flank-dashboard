import 'package:ci_integration/common/party/destination_party.dart';
import 'package:ci_integration/ci_integration/parties/parties.dart';
import 'package:ci_integration/firestore/party/firestore_destination_party.dart';

/// A class providing all the supported destination integrations.
class SupportedDestinationParties implements Parties<DestinationParty> {
  @override
  final List<DestinationParty> parties = List.unmodifiable([
    FirestoreDestinationParty(),
  ]);
}
