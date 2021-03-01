// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/cli/parties/configured_parties/configured_destination_party.dart';
import 'package:test/test.dart';

import '../../test_util/destination_config_stub.dart';
import '../../test_util/destination_party_stub.dart';

void main() {
  group("ConfiguredDestinationParty", () {
    final config = DestinationConfigStub();
    final party = DestinationPartyStub();

    test(
      "throws an ArgumentError if the given config is null",
      () {
        expect(
          () => ConfiguredDestinationParty(
            null,
            party,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given party is null",
      () {
        expect(
          () => ConfiguredDestinationParty(
            config,
            null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        final configuredParty = ConfiguredDestinationParty(
          config,
          party,
        );

        expect(configuredParty.config, equals(config));
        expect(configuredParty.party, equals(party));
      },
    );
  });
}
