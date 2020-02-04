import 'package:guardian/utils/junit_xml/junit_xml.dart';
import 'package:test/test.dart';

import '../../../test_utils/xml_string_parse_util.dart';

void main() {
  group('SystemErrParser', () {
    final systemErrParser = SystemErrParser();

    test('elementName should be equal to system-err', () {
      expect(systemErrParser.elementName, 'system-err');
    });

    test('parse() should parse <system-err> node text', () {
      const xml = '''
        <?xml version='1.0' encoding='UTF-8'?>
        <system-err>Random error output</system-err>
      ''';
      final xmlElement = XmlStringParseUtil.parseXml(xml);

      final result = systemErrParser.parse(xmlElement);

      const expected = JUnitSystemErrData(text: 'Random error output');
      expect(result, equals(expected));
    });

    test('parse() should parse empty <system-err> node text as empty', () {
      const xml = '''
        <?xml version='1.0' encoding='UTF-8'?>
        <system-err></system-err>
      ''';
      final xmlElement = XmlStringParseUtil.parseXml(xml);

      final result = systemErrParser.parse(xmlElement);

      const expected = JUnitSystemErrData(text: '');
      expect(result, equals(expected));
    });

    test(
      'parse() should parse self-closing <system-err/> node text as empty',
      () {
        const xml = '''
          <?xml version='1.0' encoding='UTF-8'?>
          <system-err/>
        ''';
        final xmlElement = XmlStringParseUtil.parseXml(xml);

        final result = systemErrParser.parse(xmlElement);

        const expected = JUnitSystemErrData(text: '');
        expect(result, equals(expected));
      },
    );
  });
}
