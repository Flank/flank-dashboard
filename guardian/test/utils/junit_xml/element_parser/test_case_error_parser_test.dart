import 'package:guardian/utils/junit_xml/junit_xml.dart';
import 'package:test/test.dart';

import '../../../test_utils/xml_string_parse_util.dart';

void main() {
  group('TestCaseErrorParser', () {
    final testCaseErrorParser = TestCaseErrorParser();

    test('elementName should be equal to error', () {
      expect(testCaseErrorParser.elementName, 'error');
    });

    test('parse() should parse <error> node text', () {
      const xml = '''
        <?xml version='1.0' encoding='UTF-8'?>
        <error>Random error</error>
      ''';
      final xmlElement = XmlStringParseUtil.parseXml(xml);

      final result = testCaseErrorParser.parse(xmlElement);

      const expected = JUnitTestCaseError(text: 'Random error');
      expect(result, equals(expected));
    });

    test('parse() should parse empty <error> node text as empty', () {
      const xml = '''
        <?xml version='1.0' encoding='UTF-8'?>
        <error></error>
      ''';
      final xmlElement = XmlStringParseUtil.parseXml(xml);

      final result = testCaseErrorParser.parse(xmlElement);

      const expected = JUnitTestCaseError(text: '');
      expect(result, equals(expected));
    });

    test(
      'parse() should parse self-closing <error/> node text as empty',
      () {
        const xml = '''
          <?xml version='1.0' encoding='UTF-8'?>
          <error/>
        ''';
        final xmlElement = XmlStringParseUtil.parseXml(xml);

        final result = testCaseErrorParser.parse(xmlElement);

        const expected = JUnitTestCaseError(text: '');
        expect(result, equals(expected));
      },
    );
  });
}
