// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/cli/configured_parties/configured_source_party.dart';
import 'package:test/test.dart';

import '../test_util/source_config_stub.dart';
import '../test_util/source_party_stub.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("ConfiguredSourceParty", () {
    final config = SourceConfigStub();
    final party = SourcePartyStub();

    test(
      "throws an ArgumentError if the given config is null",
      () {
        expect(
          () => ConfiguredSourceParty(
            config: null,
            party: party,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given party is null",
      () {
        expect(
          () => ConfiguredSourceParty(
            config: config,
            party: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        final configuredParty = ConfiguredSourceParty(
          config: config,
          party: party,
        );

        expect(configuredParty.config, equals(config));
        expect(configuredParty.party, equals(party));
      },
    );
  });
}
