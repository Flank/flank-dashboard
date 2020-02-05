import 'package:guardian/utils/junit_xml/junit_xml.dart';
import 'package:test/test.dart';

import '../test_utils/xml_string_parse_util.dart';

void main() {
  group('PropertiesParser', () {
    final parser = PropertiesParser();

    test('parse() should parse empty node as empty list of properties', () {
      const xml = '''
        <?xml version='1.0' encoding='UTF-8'?>
        <properties/>
      ''';
      final xmlElement = XmlStringParseUtil.parseXml(xml);
      final result = parser.parse(xmlElement);

      expect(result, isEmpty);
    });

    test('parse() should parse list of properties', () {
      const xml = '''
        <?xml version='1.0' encoding='UTF-8'?>
        <properties>
          <property name="var1" value="1"/>
          <property name="var2" value="2"/>
        </properties>
      ''';
      final xmlElement = XmlStringParseUtil.parseXml(xml);
      final result = parser.parse(xmlElement);

      final expected = List<JUnitProperty>.generate(2, (int index) {
        final _index = index + 1;
        return JUnitProperty(name: 'var$_index', value: '$_index');
      });
      expect(result, equals(expected));
    });
  });

  group('PropertyParser', () {
    final parser = PropertyParser();
    test(
      'parse() should throw FormatException on missing required attribute(s)',
      () {
        const xml = '''
          <?xml version='1.0' encoding='UTF-8'?>
          <property/>
        ''';
        final xmlElement = XmlStringParseUtil.parseXml(xml);

        expect(() => parser.parse(xmlElement), throwsFormatException);
      },
    );

    test('parse() should parse property', () {
      const xml = '''
        <?xml version='1.0' encoding='UTF-8'?>
        <property name="var1" value="1"/>
      ''';
      final xmlElement = XmlStringParseUtil.parseXml(xml);
      final result = parser.parse(xmlElement);

      const expected = JUnitProperty(name: 'var1', value: '1');
      expect(result, equals(expected));
    });
  });
}
