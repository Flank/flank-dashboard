// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/cli/parties/configured_parties/configured_party.dart';
import 'package:ci_integration/integration/interface/base/client/integration_client.dart';
import 'package:ci_integration/integration/interface/base/client_factory/integration_client_factory.dart';
import 'package:ci_integration/integration/interface/base/config/model/config.dart';
import 'package:ci_integration/integration/interface/base/config/parser/config_parser.dart';
import 'package:ci_integration/integration/interface/base/config/validator_factory/config_validator_factory.dart';
import 'package:ci_integration/integration/interface/base/party/integration_party.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("ConfiguredParty", () {
    final config = _ConfigStub();
    final party = _IntegrationPartyStub();

    test(
      "throws an ArgumentError if the given config is null",
      () {
        expect(() => _ConfiguredPartyFake(null, party), throwsArgumentError);
      },
    );

    test(
      "throws an ArgumentError if the given party is null",
      () {
        expect(() => _ConfiguredPartyFake(config, null), throwsArgumentError);
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        final configuredParty = _ConfiguredPartyFake(config, party);

        expect(configuredParty.config, equals(config));
        expect(configuredParty.party, equals(party));
      },
    );
  });
}

/// A stub implementation of the [Config] to use in tests.
class _ConfigStub extends Config {}

/// A stub implementation of the [IntegrationParty] to use in tests.
class _IntegrationPartyStub extends IntegrationParty {
  @override
  IntegrationClientFactory<Config, IntegrationClient> get clientFactory => null;

  @override
  ConfigParser<Config> get configParser => null;

  @override
  ConfigValidatorFactory<Config> get configValidatorFactory => null;
}

/// A fake implementation of the [ConfiguredParty] class needed to test the [ConfiguredParty] class.
class _ConfiguredPartyFake extends ConfiguredParty {
  /// Creates a new intance of the [_ConfiguredPartyFake] with the given
  /// parameters.
  _ConfiguredPartyFake(
    Config config,
    IntegrationParty<Config, IntegrationClient> party,
  ) : super(config, party);
}
