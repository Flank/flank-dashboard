import 'package:guardian/utils/yaml/yaml_map_formatter.dart';
import 'package:guardian/utils/yaml/yaml_map_parser.dart';
import 'package:test/test.dart';

void main() {
  group('YamlMapFormatter', () {
    final formatter = YamlMapFormatter();

    test('should use default indentation if not given', () {
      final _formatter = YamlMapFormatter();

      expect(_formatter.spacesPerIndentationLevel,
          YamlMapFormatter.defaultSpacesPerIndentationLevel);
    });

    test('format() should throw ArgumentError if input is null', () {
      expect(() => formatter.format(null), throwsArgumentError);
    });

    test('format() should return empty string on empty input', () {
      final result = formatter.format({});

      expect(result, '');
    });

    test('format() should format DateTime values to ISO 8601 in UTC', () {
      final dateTime = DateTime.now();
      final result = formatter.format({'dateTime': dateTime});

      expect(
        result,
        equals("dateTime: '${dateTime.toUtc().toIso8601String()}'\n"),
      );
    });

    test(
        'format() should throw FormatException '
        'parsing String containig both \' and \"', () {
      const value = 'some \'value\"';

      expect(() => formatter.format({'string': value}), throwsFormatException);
    });

    test('format() should format String values with quotes', () {
      const value = 'value';
      final result = formatter.format({'string': value});

      expect(result, equals("string: '$value'\n"));
    });

    test('format() should format num values', () {
      const valueInt = 1;
      const valueDouble = 1.0;
      final result = formatter.format({
        'int': valueInt,
        'double': valueDouble,
      });

      expect(result, equals('int: $valueInt\ndouble: $valueDouble\n'));
    });

    test('format() should format List values', () {
      const valueList = [1];
      final result = formatter.format({'list': valueList});

      expect(
        result,
        equals("list: \n${' ' * formatter.spacesPerIndentationLevel}- 1\n"),
      );
    });

    test(
        'format() should throw FormatException trying to format '
        'not of type num, String, DateTime, Map<String, dynamic>, List', () {
      expect(
        () => formatter.format({'object': Object()}),
        throwsFormatException,
      );
    });
  });

  group('YamlMapParser', () {
    const parser = YamlMapParser();

    test('parse() should throw ArgumentError if input is not dictionary', () {
      const yamlString = '1';

      expect(() => parser.parse(yamlString), throwsArgumentError);
    });

    test('parse() should throw ArgumentError if input is null', () {
      expect(() => parser.parse(null), throwsArgumentError);
    });

    test('parse() should return empty map on empty input', () {
      const yamlString = '';
      final result = parser.parse(yamlString);

      expect(result, isEmpty);
    });

    test('parse() should throw FormatException if input has complex keys', () {
      const yamlString = '{1, 2}: 3';

      expect(() => parser.parse(yamlString), throwsFormatException);
    });

    test('parse() should parse nested YAML dictionaries', () {
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

    test('parse() should parse YAML lists', () {
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

    test('parse() should parse YAML strings', () {
      // Formatted yaml string
      // string: 'value'
      const yamlString = "string: 'value'";
      final result = parser.parse(yamlString);

      expect(result, equals({'string': 'value'}));
    });

    test('parse() should parse YAML nums', () {
      // Formatted yaml string
      // int: 1
      // double: 1.0
      const yamlString = 'int: 1\ndouble: 1.0';
      final result = parser.parse(yamlString);

      expect(result, equals({'int': 1, 'double': 1.0}));
    });
  });
}
