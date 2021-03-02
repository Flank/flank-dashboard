// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/cli/config/model/raw_integration_config.dart';
import 'package:ci_integration/cli/configured_parties/factory/configured_parties_factory.dart';
import 'package:ci_integration/cli/parties/supported_integration_parties.dart';
import 'package:ci_integration/integration/interface/destination/config/model/destination_config.dart';
import 'package:ci_integration/integration/interface/destination/party/destination_party.dart';
import 'package:ci_integration/integration/interface/source/config/model/source_config.dart';
import 'package:ci_integration/integration/interface/source/party/source_party.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../test_util/destination_config_stub.dart';
import '../../test_util/mock/config_parser_mock.dart';
import '../../test_util/mock/parties_mock.dart';
import '../../test_util/source_config_stub.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("ConfiguredPartiesFactory", () {
    const sourceConfigMap = {'source': 'config'};
    const destinationConfigMap = {'destination': 'config'};

    final rawConfig = RawIntegrationConfig(
      sourceConfigMap: sourceConfigMap,
      destinationConfigMap: destinationConfigMap,
    );

    final sourceConfig = SourceConfigStub();
    final destinationConfig = DestinationConfigStub();

    final sourceParties = PartiesMock<SourceParty>();
    final destinationParties = PartiesMock<DestinationParty>();

    final supportedParties = SupportedIntegrationParties(
      sourceParties: sourceParties,
      destinationParties: destinationParties,
    );

    final configuredPartiesFactory = ConfiguredPartiesFactory(supportedParties);

    final sourceParty = _SourcePartyMock();
    final destinationParty = _DestinationPartyMock();

    final sourceConfigParser = ConfigParserMock<SourceConfig>();
    final destinationConfigParser = ConfigParserMock<DestinationConfig>();

    tearDown(() {
      reset(sourceParties);
      reset(destinationParties);
      reset(sourceParty);
      reset(destinationParty);
      reset(sourceConfigParser);
      reset(destinationConfigParser);
    });

    PostExpectation<SourceConfig> whenParseSourceConfig({
      Map<String, dynamic> withSourceConfigMap,
    }) {
      when(sourceParties.getParty(withSourceConfigMap)).thenReturn(
        sourceParty,
      );
      when(sourceParty.configParser).thenReturn(sourceConfigParser);

      return when(sourceConfigParser.parse(withSourceConfigMap));
    }

    PostExpectation<DestinationConfig> whenParseDestinationConfig({
      Map<String, dynamic> withDestinationConfigMap,
    }) {
      when(
        destinationParties.getParty(withDestinationConfigMap),
      ).thenReturn(destinationParty);
      when(destinationParty.configParser).thenReturn(destinationConfigParser);

      return when(destinationConfigParser.parse(withDestinationConfigMap));
    }

    test(
      "creates an instance with the given supported integration parties",
      () {
        final configuredPartiesFactory = ConfiguredPartiesFactory(
          supportedParties,
        );

        expect(
          configuredPartiesFactory.supportedParties,
          equals(supportedParties),
        );
      },
    );

    test(
      "creates an instance with the default supported integration parties, if the given supported integration parties is null",
      () {
        final configuredPartiesFactory = ConfiguredPartiesFactory(null);

        expect(configuredPartiesFactory.supportedParties, isNotNull);
      },
    );

    test(
      ".create() throws an ArgumentError if the given raw integration config is null",
      () {
        expect(
          () => configuredPartiesFactory.create(null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".create() calls .getParty() of the source parties to determine the source party that accepts the source config",
      () {
        whenParseSourceConfig(
          withSourceConfigMap: sourceConfigMap,
        ).thenReturn(sourceConfig);
        whenParseDestinationConfig(
          withDestinationConfigMap: destinationConfigMap,
        ).thenReturn(destinationConfig);

        configuredPartiesFactory.create(rawConfig);

        verify(sourceParties.getParty(sourceConfigMap)).called(1);
      },
    );

    test(
      ".create() parses the source config map to the source config using the source config parser",
      () {
        whenParseSourceConfig(
          withSourceConfigMap: sourceConfigMap,
        ).thenReturn(sourceConfig);
        whenParseDestinationConfig(
          withDestinationConfigMap: destinationConfigMap,
        ).thenReturn(destinationConfig);

        configuredPartiesFactory.create(rawConfig);

        verify(sourceConfigParser.parse(sourceConfigMap)).called(1);
      },
    );

    test(
      ".create() calls .getParty() of the destination parties to determine the destination party that accepts the destination config",
      () {
        whenParseSourceConfig(
          withSourceConfigMap: sourceConfigMap,
        ).thenReturn(sourceConfig);
        whenParseDestinationConfig(
          withDestinationConfigMap: destinationConfigMap,
        ).thenReturn(destinationConfig);

        configuredPartiesFactory.create(rawConfig);

        verify(destinationParties.getParty(destinationConfigMap)).called(1);
      },
    );

    test(
      ".create() parses the destination config map to the destination config using the destination config parser",
      () {
        whenParseSourceConfig(
          withSourceConfigMap: sourceConfigMap,
        ).thenReturn(sourceConfig);
        whenParseDestinationConfig(
          withDestinationConfigMap: destinationConfigMap,
        ).thenReturn(destinationConfig);

        configuredPartiesFactory.create(rawConfig);

        verify(destinationConfigParser.parse(destinationConfigMap)).called(1);
      },
    );

    test(
      ".create() returns the configured parties with the configured source party with the source party that accepts the given source config",
      () {
        whenParseSourceConfig(
          withSourceConfigMap: sourceConfigMap,
        ).thenReturn(sourceConfig);
        whenParseDestinationConfig(
          withDestinationConfigMap: destinationConfigMap,
        ).thenReturn(destinationConfig);

        final configuredParties = configuredPartiesFactory.create(rawConfig);

        final configuredSourceParty = configuredParties.configuredSourceParty;

        expect(configuredSourceParty.party, equals(sourceParty));
      },
    );

    test(
      ".create() returns the configured parties with the configured source party with the parsed source config",
      () {
        whenParseSourceConfig(
          withSourceConfigMap: sourceConfigMap,
        ).thenReturn(sourceConfig);
        whenParseDestinationConfig(
          withDestinationConfigMap: destinationConfigMap,
        ).thenReturn(destinationConfig);

        final configuredParties = configuredPartiesFactory.create(rawConfig);

        final configuredSourceParty = configuredParties.configuredSourceParty;

        expect(configuredSourceParty.config, equals(sourceConfig));
      },
    );

    test(
      ".create() returns the configured parties with the configured destination party with the destination party that accepts the given destination config",
      () {
        whenParseSourceConfig(
          withSourceConfigMap: sourceConfigMap,
        ).thenReturn(sourceConfig);
        whenParseDestinationConfig(
          withDestinationConfigMap: destinationConfigMap,
        ).thenReturn(destinationConfig);

        final configuredParties = configuredPartiesFactory.create(rawConfig);

        final configuredDestinationParty =
            configuredParties.configuredDestinationParty;

        expect(configuredDestinationParty.party, equals(destinationParty));
      },
    );

    test(
      ".create() returns the configured parties with the configured destination party with the parsed destination config",
      () {
        whenParseSourceConfig(
          withSourceConfigMap: sourceConfigMap,
        ).thenReturn(sourceConfig);
        whenParseDestinationConfig(
          withDestinationConfigMap: destinationConfigMap,
        ).thenReturn(destinationConfig);

        final configuredParties = configuredPartiesFactory.create(rawConfig);

        final configuredDestinationParty =
            configuredParties.configuredDestinationParty;

        expect(configuredDestinationParty.config, equals(destinationConfig));
      },
    );
  });
}

class _SourcePartyMock extends Mock implements SourceParty {}

class _DestinationPartyMock extends Mock implements DestinationParty {}
