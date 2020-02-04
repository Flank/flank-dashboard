import 'package:guardian/utils/junit_xml/junit_xml.dart';
import 'package:test/test.dart';

import '../../../test_utils/xml_string_parse_util.dart';

void main() {
  group('TestCaseFailureParser', () {
    final testCaseFailureParser = TestCaseFailureParser();

    test('elementName should be equal to failure', () {
      expect(testCaseFailureParser.elementName, 'failure');
    });

    test('parse() should parse <failure> node text', () {
      const xml = '''
        <?xml version='1.0' encoding='UTF-8'?>
        <failure>Random failure</failure>
      ''';
      final xmlElement = XmlStringParseUtil.parseXml(xml);

      final result = testCaseFailureParser.parse(xmlElement);

      const expected = JUnitTestCaseFailure(text: 'Random failure');
      expect(result, equals(expected));
    });

    test('parse() should parse empty <failure> node text as empty', () {
      const xml = '''
        <?xml version='1.0' encoding='UTF-8'?>
        <failure></failure>
      ''';
      final xmlElement = XmlStringParseUtil.parseXml(xml);

      final result = testCaseFailureParser.parse(xmlElement);

      const expected = JUnitTestCaseFailure(text: '');
      expect(result, equals(expected));
    });

    test(
      'parse() should parse self-closing <failure/> node text as empty',
      () {
        const xml = '''
          <?xml version='1.0' encoding='UTF-8'?>
          <failure/>
        ''';
        final xmlElement = XmlStringParseUtil.parseXml(xml);

        final result = testCaseFailureParser.parse(xmlElement);

        const expected = JUnitTestCaseFailure(text: '');
        expect(result, equals(expected));
      },
    );
  });
}
