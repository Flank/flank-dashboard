// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/source/buildkite/config/parser/buildkite_source_config_parser.dart';
import 'package:test/test.dart';

import '../../test_utils/test_data/buildkite_config_test_data.dart';

void main() {
  group("BuildkiteSourceConfigParser", () {
    const configMap = {
      'buildkite': BuildkiteConfigTestData.sourceConfigMap,
    };

    const buildkiteSourceConfigParser = BuildkiteSourceConfigParser();

    test(
      ".canParse() returns false if the given map is null",
      () {
        final canParse = buildkiteSourceConfigParser.canParse(null);

        expect(canParse, isFalse);
      },
    );

    test(
      ".canParse() returns false if the given map does not contain a Buildkite key",
      () {
        final map = {'test': {}};

        final canParse = buildkiteSourceConfigParser.canParse(map);

        expect(canParse, isFalse);
      },
    );

    test(
      ".canParse() returns true if the parser can parse the given map",
      () {
        final canParse = buildkiteSourceConfigParser.canParse(configMap);

        expect(canParse, isTrue);
      },
    );

    test(
      ".parse() returns null if the given map is null",
      () {
        final result = buildkiteSourceConfigParser.parse(null);

        expect(result, isNull);
      },
    );

    test(
      ".parse() returns null if the given map does not contain a Buildkite key",
      () {
        final map = {'test': {}};

        final result = buildkiteSourceConfigParser.parse(map);

        expect(result, isNull);
      },
    );

    test(
      ".parse() parses the given map into the Buildkite source config",
      () {
        final expected = BuildkiteConfigTestData.sourceConfig;

        final result = buildkiteSourceConfigParser.parse(configMap);

        expect(result, equals(expected));
      },
    );
  });
}
