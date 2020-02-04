import 'package:guardian/utils/junit_xml/junit_xml.dart';
import 'package:test/test.dart';

import '../../../test_utils/xml_string_parse_util.dart';

void main() {
  group('TestCaseSkippedParser', () {
    final testCaseSkippedParser = TestCaseSkippedParser();

    test('elementName should be equal to skipped', () {
      expect(testCaseSkippedParser.elementName, 'skipped');
    });

    test('parse() should parse <skipped> node text', () {
      const xml = '''
        <?xml version='1.0' encoding='UTF-8'?>
        <skipped>Random skipped</skipped>
      ''';
      final xmlElement = XmlStringParseUtil.parseXml(xml);

      final result = testCaseSkippedParser.parse(xmlElement);

      const expected = JUnitTestCaseSkipped(text: 'Random skipped');
      expect(result, equals(expected));
    });

    test('parse() should parse empty <skipped> node text as empty', () {
      const xml = '''
        <?xml version='1.0' encoding='UTF-8'?>
        <skipped></skipped>
      ''';
      final xmlElement = XmlStringParseUtil.parseXml(xml);

      final result = testCaseSkippedParser.parse(xmlElement);

      const expected = JUnitTestCaseSkipped(text: '');
      expect(result, equals(expected));
    });

    test(
      'parse() should parse self-closing <skipped/> node text as empty',
      () {
        const xml = '''
          <?xml version='1.0' encoding='UTF-8'?>
          <skipped/>
        ''';
        final xmlElement = XmlStringParseUtil.parseXml(xml);

        final result = testCaseSkippedParser.parse(xmlElement);

        const expected = JUnitTestCaseSkipped(text: '');
        expect(result, equals(expected));
      },
    );
  });
}
