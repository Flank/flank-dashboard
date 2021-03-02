// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/cli/configured_parties/configured_destination_party.dart';
import 'package:ci_integration/cli/configured_parties/configured_parties.dart';
import 'package:ci_integration/cli/configured_parties/configured_source_party.dart';
import 'package:test/test.dart';

import '../test_util/destination_config_stub.dart';
import '../test_util/destination_party_stub.dart';
import '../test_util/source_config_stub.dart';
import '../test_util/source_party_stub.dart';

void main() {
  group("ConfiguredParties", () {
    final sourceConfig = SourceConfigStub();
    final sourceParty = SourcePartyStub();
    final configuredSourceParty = ConfiguredSourceParty(
      config: sourceConfig,
      party: sourceParty,
    );
    final destinationConfig = DestinationConfigStub();
    final destinationParty = DestinationPartyStub();
    final configuredDestinationParty = ConfiguredDestinationParty(
      config: destinationConfig,
      party: destinationParty,
    );

    test(
      "throws an ArgumentError if the given configured source party is null",
      () {
        expect(
          () => ConfiguredParties(null, configuredDestinationParty),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given configured destination party is null",
      () {
        expect(
          () => ConfiguredParties(configuredSourceParty, null),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        final configuredParties = ConfiguredParties(
          configuredSourceParty,
          configuredDestinationParty,
        );

        final resultSourceParty = configuredParties.configuredSourceParty;
        final resultDestinationParty =
            configuredParties.configuredDestinationParty;

        expect(resultSourceParty, equals(configuredSourceParty));
        expect(resultDestinationParty, equals(configuredDestinationParty));
      },
    );
  });
}
