import 'package:guardian/utils/junit_xml/junit_xml.dart';
import 'package:test/test.dart';

import '../test_utils/xml_string_parse_util.dart';

void main() {
  group('TestSuiteParser', () {
    final parser = TestSuiteParser();

    test(
      'parse() should throw FormatException if <testsuite> node '
      'contains more than 1 <system-out> nodes',
      () {
        const xml = '''
          <?xml version='1.0' encoding='UTF-8'?>
          <testsuite>
            <system-out/>
            <system-out/>
          </testsuite>
        ''';
        final xmlElement = XmlStringParseUtil.parseXml(xml);

        expect(() => parser.parse(xmlElement), throwsFormatException);
      },
    );

    test(
      'parse() should throw FormatException if <testsuite> node '
      'contains more than 1 <system-err> nodes',
      () {
        const xml = '''
          <?xml version='1.0' encoding='UTF-8'?>
          <testsuite>
            <system-err/>
            <system-err/>
          </testsuite>
        ''';
        final xmlElement = XmlStringParseUtil.parseXml(xml);

        expect(() => parser.parse(xmlElement), throwsFormatException);
      },
    );

    test(
      'parse() should throw FormatException if <testsuite> node '
      'contains more than 1 <properties> nodes',
      () {
        const xml = '''
          <?xml version='1.0' encoding='UTF-8'?>
          <testsuite>
            <properties/>
            <properties/>
          </testsuite>
        ''';
        final xmlElement = XmlStringParseUtil.parseXml(xml);

        expect(() => parser.parse(xmlElement), throwsFormatException);
      },
    );

    test(
      'parse() should throw FormatException on missing required attribute(s)',
      () {
        const xml = '''
          <?xml version='1.0' encoding='UTF-8'?>
          <testsuite/>
        ''';
        final xmlElement = XmlStringParseUtil.parseXml(xml);

        expect(() => parser.parse(xmlElement), throwsFormatException);
      },
    );

    test('parse() should parse <testsuite> node', () {
      const xml = '''
        <?xml version='1.0' encoding='UTF-8'?>
        <testsuite name="RandomClass" tests="1" errors="0" failures="0" time="0.123" hostname="localhost">
          <testcase name="randomTestCase()" classname="RandomClass" time="0.123"/>
        </testsuite>
      ''';
      final xmlElement = XmlStringParseUtil.parseXml(xml);
      final result = parser.parse(xmlElement);

      const expected = JUnitTestSuite(
        name: 'RandomClass',
        tests: 1,
        errors: 0,
        failures: 0,
        time: 0.123,
        hostname: 'localhost',
        testCases: [
          JUnitTestCase(
            name: 'randomTestCase()',
            classname: 'RandomClass',
            time: 0.123,
          ),
        ],
      );
      expect(result, equals(expected));
    });
  });
}
