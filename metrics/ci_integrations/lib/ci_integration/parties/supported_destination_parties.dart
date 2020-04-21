import 'package:ci_integration/common/party/destination_party.dart';
import 'package:ci_integration/common/party/parties.dart';
import 'package:ci_integration/firestore/party/firestore_destination_party.dart';

class SupportedDestinationParties implements Parties<DestinationParty> {
  @override
  final List<DestinationParty> parties = List.unmodifiable([
    FirestoreDestinationParty(),
  ]);
}
