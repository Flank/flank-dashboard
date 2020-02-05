import 'package:guardian/utils/junit_xml/junit_xml.dart';
import 'package:test/test.dart';

import '../test_utils/xml_string_parse_util.dart';

void main() {
  group('TestCaseParser', () {
    final parser = TestCaseParser();
    test(
      'parse() should throw FormatException if <testcase> node '
      'contains more than 1 <system-out> nodes',
      () {
        const xml = '''
          <?xml version='1.0' encoding='UTF-8'?>
          <testcase>
            <system-out/>
            <system-out/>
          </testcase>
        ''';
        final xmlElement = XmlStringParseUtil.parseXml(xml);

        expect(() => parser.parse(xmlElement), throwsFormatException);
      },
    );

    test(
      'parse() should throw FormatException if <testcase> node '
      'contains more than 1 <system-err> nodes',
      () {
        const xml = '''
          <?xml version='1.0' encoding='UTF-8'?>
          <testcase>
            <system-err/>
            <system-err/>
          </testcase>
        ''';
        final xmlElement = XmlStringParseUtil.parseXml(xml);

        expect(() => parser.parse(xmlElement), throwsFormatException);
      },
    );

    test('parse() should parse empty <testcase/> node', () {
      const xml = '''
        <?xml version='1.0' encoding='UTF-8'?>
        <testcase/>
      ''';
      final xmlElement = XmlStringParseUtil.parseXml(xml);
      final result = parser.parse(xmlElement);

      expect(result, equals(const JUnitTestCase()));
    });

    test('parse() should parse <testcase> node', () {
      const xml = '''
        <?xml version='1.0' encoding='UTF-8'?>
        <testcase name="randomTestCase()" classname="RandomClass" time="0.123">
          <failure>Exception: RandomException</failure>
          <failure>Random stack trace</failure>
          <system-out/>
          <system-err>Error occurred</system-err>
        </testcase>
      ''';
      final xmlElement = XmlStringParseUtil.parseXml(xml);
      final result = parser.parse(xmlElement);

      const expected = JUnitTestCase(
        name: 'randomTestCase()',
        classname: 'RandomClass',
        time: 0.123,
        failures: [
          JUnitTestCaseFailure(text: 'Exception: RandomException'),
          JUnitTestCaseFailure(text: 'Random stack trace'),
        ],
        systemOut: JUnitSystemOutData(text: ''),
        systemErr: JUnitSystemErrData(text: 'Error occurred'),
      );
      expect(result, equals(expected));
    });
  });
}
