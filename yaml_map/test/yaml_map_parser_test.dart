// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:test/test.dart';
import 'package:yaml_map/yaml_map.dart';

void main() {
  group('YamlMapParser', () {
    const parser = YamlMapParser();

    test(
      "parse() throws an ArgumentError if the given input is not a dictionary",
      () {
        const yamlString = '1';

        expect(() => parser.parse(yamlString), throwsArgumentError);
      },
    );

    test("parse() throws an ArgumentError if the given input is null", () {
      expect(() => parser.parse(null), throwsArgumentError);
    });

    test("parse() returns an empty map on empty input", () {
      const yamlString = '';
      final result = parser.parse(yamlString);

      expect(result, isEmpty);
    });

    test(
      "parse() throws a FormatException if the given input has complex keys",
      () {
        const yamlString = '{1, 2}: 3';

        expect(() => parser.parse(yamlString), throwsFormatException);
      },
    );

    test("parse() parses nested YAML dictionaries", () {
      // Formatted yaml string
      // f1:
      //   f2: 1
      //   f3: 2
      const yamlString = 'f1:\n  f2: 1\n  f3: 2';
      final result = parser.parse(yamlString);

      expect(
        result,
        equals({
          'f1': {
            'f2': 1,
            'f3': 2,
          }
        }),
      );
    });

    test("parse() parses YAML lists", () {
      // Formatted yaml string
      // list:
      //   - 1
      //   - 2
      const yamlString = 'list:\n  - 1\n  - 2';
      final result = parser.parse(yamlString);

      expect(
        result,
        equals({
          'list': [1, 2]
        }),
      );
    });

    test("parse() parses YAML strings", () {
      // Formatted yaml string
      // string: 'value'
      const yamlString = "string: 'value'";
      final result = parser.parse(yamlString);

      expect(result, equals({'string': 'value'}));
    });

    test("parse() parses YAML nums", () {
      // Formatted yaml string
      // int: 1
      // double: 1.0
      const yamlString = 'int: 1\ndouble: 1.0';
      final result = parser.parse(yamlString);

      expect(result, equals({'int': 1, 'double': 1.0}));
    });
  });
}
