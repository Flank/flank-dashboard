import 'package:guardian/utils/junit_xml/junit_xml.dart';
import 'package:test/test.dart';

import '../test_utils/xml_string_parse_util.dart';

void main() {
  group('TestSuitesParser', () {
    final parser = TestSuitesParser();

    test('parse() should parse empty <testsuites> node', () {
      const xml = '''
        <?xml version='1.0' encoding='UTF-8'?>
        <testsuites></testsuites>
      ''';
      final xmlElement = XmlStringParseUtil.parseXml(xml);
      final result = parser.parse(xmlElement);

      expect(result, equals(const JUnitTestSuites(testSuites: [])));
    });

    test('parse() should parse <testsuites> node', () {
      const xml = '''
        <?xml version='1.0' encoding='UTF-8'?>
        <testsuites tests="1" time="0.123">
          <testsuite name="RandomClass" tests="1" errors="0" failures="0" time="0.123" hostname="localhost">
            <testcase name="randomTestCase()" classname="RandomClass" time="0.123"/>
            </testsuite>
        </testsuites>
      ''';
      final xmlElement = XmlStringParseUtil.parseXml(xml);
      final result = parser.parse(xmlElement);

      const expected = JUnitTestSuites(
        tests: 1,
        time: 0.123,
        testSuites: [
          JUnitTestSuite(
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
          ),
        ],
      );
      expect(result, equals(expected));
    });
  });
}
