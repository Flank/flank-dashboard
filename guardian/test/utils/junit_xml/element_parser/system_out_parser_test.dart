import 'package:guardian/utils/junit_xml/junit_xml.dart';
import 'package:test/test.dart';

import '../../../test_utils/xml_string_parse_util.dart';

void main() {
  group('SystemOutParser', () {
    final systemOutParser = SystemOutParser();

    test('elementName should be equal to system-out', () {
      expect(systemOutParser.elementName, 'system-out');
    });

    test('parse() should parse <system-out> node text', () {
      const xml = '''
        <?xml version='1.0' encoding='UTF-8'?>
        <system-out>Random output</system-out>
      ''';
      final xmlElement = XmlStringParseUtil.parseXml(xml);

      final result = systemOutParser.parse(xmlElement);

      const expected = JUnitSystemOutData(text: 'Random output');
      expect(result, equals(expected));
    });

    test('parse() should parse empty <system-out> node text as empty', () {
      const xml = '''
        <?xml version='1.0' encoding='UTF-8'?>
        <system-out></system-out>
      ''';
      final xmlElement = XmlStringParseUtil.parseXml(xml);

      final result = systemOutParser.parse(xmlElement);

      const expected = JUnitSystemOutData(text: '');
      expect(result, equals(expected));
    });

    test(
      'parse() should parse self-closing <system-out/> node text as empty',
      () {
        const xml = '''
          <?xml version='1.0' encoding='UTF-8'?>
          <system-out/>
        ''';
        final xmlElement = XmlStringParseUtil.parseXml(xml);

        final result = systemOutParser.parse(xmlElement);

        const expected = JUnitSystemOutData(text: '');
        expect(result, equals(expected));
      },
    );
  });
}
