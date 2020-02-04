import 'package:guardian/utils/junit_xml/junit_xml.dart';
import 'package:test/test.dart';

void main() {
  group('XmlAttributeValueParser', () {
    final parser = IntAttributeValueParser();

    test('canParse() should return true if value can be parsed', () {
      const value = '123';
      final canParse = parser.canParse(value);
      expect(canParse, isTrue);
    });

    test('canParse() should return false if value cannot be parsed', () {
      const value = 'no int';
      final canParse = parser.canParse(value);
      expect(canParse, isFalse);
    });

    test(
      'parse() should throw FormatException on value that cannot be parsed',
      () {
        const value = 'no int';
        expect(() => parser.parse(value), throwsFormatException);
      },
    );

    test('parse() should parse valid value', () {
      const value = '123';
      final parsed = parser.parse(value);
      expect(parsed, equals(123));
    });

    test('tryParse() should return null on value that cannot be parsed', () {
      const value = 'no int';
      final parsed = parser.tryParse(value);
      expect(parsed, isNull);
    });

    test('tryParse() should parse valid value', () {
      const value = '123';
      final parsed = parser.tryParse(value);
      expect(parsed, equals(123));
    });

    group('StringAttributeValueParser', () {
      test('parseString() should throw FormatException on null input', () {
        const String value = null;
        expect(
          () => StringAttributeValueParser.parseString(value),
          throwsFormatException,
        );
      });

      test('parseString() should return value on non-null input', () {
        const value = 'any';
        final result = StringAttributeValueParser.parseString(value);
        expect(result, equals(value));
      });
    });
  });
}
