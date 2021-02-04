// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/cli/parties/supported_destination_parties.dart';
import 'package:ci_integration/cli/parties/supported_integration_parties.dart';
import 'package:ci_integration/cli/parties/supported_source_parties.dart';
import 'package:ci_integration/integration/interface/destination/party/destination_party.dart';
import 'package:ci_integration/integration/interface/source/party/source_party.dart';
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
      "creates default SupportedSourceParties instance if no source parties are given",
      () {
        final parties = SupportedIntegrationParties(
          destinationParties: destinationPartiesMock,
        );

        expect(parties.sourceParties, isNotNull);
        expect(parties.sourceParties, isA<SupportedSourceParties>());
      },
    );

    test(
      "creates default SupportedDestinationParties instance if no destination parties are given",
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
