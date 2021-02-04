// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:test/test.dart';
import 'package:yaml_map/yaml_map.dart';

void main() {
  group('YamlMapFormatter', () {
    final formatter = YamlMapFormatter();

    test("uses default indentation if not given", () {
      final _formatter = YamlMapFormatter();

      expect(_formatter.spacesPerIndentationLevel,
          YamlMapFormatter.defaultSpacesPerIndentationLevel);
    });

    test("format() throws an ArgumentError if the input is null", () {
      expect(() => formatter.format(null), throwsArgumentError);
    });

    test("format() returns an empty string on empty input", () {
      final result = formatter.format({});

      expect(result, '');
    });

    test("format() formats DateTime values to ISO 8601 in UTC", () {
      final dateTime = DateTime.now();
      final result = formatter.format({'dateTime': dateTime});

      expect(
        result,
        equals("dateTime: '${dateTime.toUtc().toIso8601String()}'\n"),
      );
    });

    test(
        "format() throws a FormatException parsing String containing both ' and \"",
        () {
      const value = 'some \'value\"';

      expect(() => formatter.format({'string': value}), throwsFormatException);
    });

    test("format() formats String values with quotes", () {
      const value = 'value';
      final result = formatter.format({'string': value});

      expect(result, equals("string: '$value'\n"));
    });

    test("format() formats num values", () {
      const valueInt = 1;
      const valueDouble = 1.0;
      final result = formatter.format({
        'int': valueInt,
        'double': valueDouble,
      });

      expect(result, equals('int: $valueInt\ndouble: $valueDouble\n'));
    });

    test("format() formats List values", () {
      const valueList = [1];
      final result = formatter.format({'list': valueList});

      expect(
        result,
        equals("list: \n${' ' * formatter.spacesPerIndentationLevel}- 1\n"),
      );
    });

    test(
      "format() throws a FormatException trying to format not of type num, String, DateTime, Map<String, dynamic>, List",
      () {
        expect(
          () => formatter.format({'object': Object()}),
          throwsFormatException,
        );
      },
    );
  });
}
