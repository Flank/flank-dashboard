import 'package:ci_integration/ci_integration/parties/supported_destination_parties.dart';
import 'package:ci_integration/ci_integration/parties/supported_integration_parties.dart';
import 'package:ci_integration/ci_integration/parties/supported_source_parties.dart';
import 'package:ci_integration/common/party/destination_party.dart';
import 'package:ci_integration/common/party/source_party.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_util/mock/parties_mock.dart';

void main() {
  group("SupportedIntegrationParties", () {
    final sourcePartiesMock = PartiesMock<SourceParty>();
    final destinationPartiesMock = PartiesMock<DestinationParty>();

    setUp(() {
      reset(sourcePartiesMock);
      reset(destinationPartiesMock);
    });

    test(
      "should create default SupportedSourceParties instance if no source parties given",
      () {
        final parties = SupportedIntegrationParties(
          destinationParties: destinationPartiesMock,
        );

        expect(parties.sourceParties, isNotNull);
        expect(parties.sourceParties, isA<SupportedSourceParties>());
      },
    );

    test(
      "should create default SupportedDestinationParties instance if no destination parties given",
      () {
        final parties = SupportedIntegrationParties(
          sourceParties: sourcePartiesMock,
        );

        expect(parties.destinationParties, isNotNull);
        expect(parties.destinationParties, isA<SupportedDestinationParties>());
      },
    );
  });
}
