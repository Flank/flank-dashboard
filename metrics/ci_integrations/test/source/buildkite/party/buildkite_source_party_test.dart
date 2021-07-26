// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/source/buildkite/client_factory/buildkite_source_client_factory.dart';
import 'package:ci_integration/source/buildkite/config/parser/buildkite_source_config_parser.dart';
import 'package:ci_integration/source/buildkite/config/validator_factory/buildkite_source_validator_factory.dart';
import 'package:ci_integration/source/buildkite/party/buildkite_source_party.dart';
import 'package:test/test.dart';

void main() {
  group("BuildkiteSourceParty", () {
    final party = BuildkiteSourceParty();

    test("uses BuildkiteSourceClientFactory as a client factory", () {
      final clientFactory = party.clientFactory;

      expect(clientFactory, isA<BuildkiteSourceClientFactory>());
    });

    test("uses BuildkiteSourceConfigParser as a config parser", () {
      final configParser = party.configParser;

      expect(configParser, isA<BuildkiteSourceConfigParser>());
    });

    test("uses BuildkiteSourceValidatorFactory as a validator factory", () {
      final validatorFactory = party.configValidatorFactory;

      expect(validatorFactory, isA<BuildkiteSourceValidatorFactory>());
    });
  });
}
