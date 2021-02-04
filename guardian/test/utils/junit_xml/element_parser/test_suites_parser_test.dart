// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:guardian/utils/junit_xml/junit_xml.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

import '../test_utils/xml_string_builder_util.dart';
import '../test_utils/xml_string_parse_util.dart';

void main() {
  group('TestSuitesParser', () {
    final parser = TestSuitesParser();

    XmlElement emptyElement;
    XmlElement testSuitesElement;

    setUpAll(() {
      emptyElement = XmlStringParseUtil.parseXml(
        XmlStringBuilderUtil.emptyNodeXml('testsuites'),
      );

      testSuitesElement = XmlStringParseUtil.parseXml('''
        <?xml version='1.0' encoding='UTF-8'?>
        <testsuites tests="1" time="0.123">
          <testsuite name="RandomClass" tests="1" errors="0" failures="0" time="0.123" hostname="localhost">
            <testcase name="randomTestCase()" classname="RandomClass" time="0.123"/>
          </testsuite>
        </testsuites>
      ''');
    });

    test("mapElement() maps an empty <testsuites> element", () {
      final result = parser.mapElement(emptyElement);

      expect(result, equals(const JUnitTestSuites(testSuites: [])));
    });

    test("mapElement() maps <testsuites> element", () {
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

      final result = parser.mapElement(testSuitesElement);

      expect(result, equals(expected));
    });
  });
}
