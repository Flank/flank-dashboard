import 'package:guardian/utils/yaml/yaml_map_formatter.dart';
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
}
