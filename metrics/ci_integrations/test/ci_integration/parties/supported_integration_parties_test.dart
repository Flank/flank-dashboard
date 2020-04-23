import 'package:ci_integration/ci_integration/parties/parties.dart';
import 'package:ci_integration/ci_integration/parties/supported_destination_parties.dart';
import 'package:ci_integration/ci_integration/parties/supported_integration_parties.dart';
import 'package:ci_integration/ci_integration/parties/supported_source_parties.dart';
import 'package:ci_integration/common/party/destination_party.dart';
import 'package:ci_integration/common/party/source_party.dart';
import 'package:test/test.dart';

void main() {
  group("SupportedIntegrationParties", () {
    test(
      "should create default SupportedSourceParties instance if no source parties given",
      () {
        final parties = SupportedIntegrationParties(
          destinationParties: _DestinationPartiesStub(),
        );

        expect(parties.sourceParties, isNotNull);
        expect(parties.sourceParties, isA<SupportedSourceParties>());
      },
    );

    test(
      "should create default SupportedDestinationParties instance if no destination parties given",
      () {
        final parties = SupportedIntegrationParties(
          sourceParties: _SourcePartiesStub(),
        );

        expect(parties.destinationParties, isNotNull);
        expect(parties.destinationParties, isA<SupportedDestinationParties>());
      },
    );
  });
}

class _SourcePartiesStub implements Parties<SourceParty> {
  @override
  List<SourceParty> parties = [];
}

class _DestinationPartiesStub implements Parties<DestinationParty> {
  @override
  List<DestinationParty> parties = [];
}
