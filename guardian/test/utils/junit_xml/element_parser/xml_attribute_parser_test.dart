// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:guardian/utils/junit_xml/junit_xml.dart';
import 'package:test/test.dart';

void main() {
  group('XmlAttributeValueParser', () {
    const parser = IntAttributeValueParser();

    test("canParse() returns true if the value can be parsed", () {
      const value = '123';

      final canParse = parser.canParse(value);

      expect(canParse, isTrue);
    });

    test("canParse() returns false if the value cannot be parsed", () {
      const value = 'no int';

      final canParse = parser.canParse(value);

      expect(canParse, isFalse);
    });

    test(
      "parse() throws a FormatException on the value that cannot be parsed",
      () {
        const value = 'no int';

        expect(() => parser.parse(value), throwsFormatException);
      },
    );

    test("parse() parses valid value", () {
      const value = '123';

      final parsed = parser.parse(value);

      expect(parsed, equals(123));
    });

    test("tryParse() returns null on the value that cannot be parsed", () {
      const value = 'no int';

      final parsed = parser.tryParse(value);

      expect(parsed, isNull);
    });

    test("tryParse() parses valid value", () {
      const value = '123';

      final parsed = parser.tryParse(value);

      expect(parsed, equals(123));
    });
  });

  group('StringAttributeValueParser', () {
    test("parseString() throws a FormatException on null input", () {
      const String value = null;

      expect(
        () => StringAttributeValueParser.parseString(value),
        throwsFormatException,
      );
    });

    test("parseString() returns value on non-null input", () {
      const value = 'any';

      final result = StringAttributeValueParser.parseString(value);

      expect(result, equals(value));
    });
  });

  group('BoolAttributeValueParser', () {
    test("parseBool() throws a FormatException on null input", () {
      const String value = null;

      expect(
        () => BoolAttributeValueParser.parseBool(value),
        throwsFormatException,
      );
    });

    test("parseBool() throws a FormatException on invalid input", () {
      const String value = 'not bool';

      expect(
        () => BoolAttributeValueParser.parseBool(value),
        throwsFormatException,
      );
    });

    test("parseBool() parses bool on valid source string", () {
      const String value = 'true';

      final result = BoolAttributeValueParser.parseBool(value);

      expect(result, isTrue);
    });

    test("tryParseBool() returns null on invalid input", () {
      const value = 'not bool';

      final result = BoolAttributeValueParser.tryParseBool(value);

      expect(result, isNull);
    });

    test("tryParseBool() parses bool on valid source string", () {
      const value = 'true';

      final result = BoolAttributeValueParser.tryParseBool(value);

      expect(result, isTrue);
    });
  });
}
