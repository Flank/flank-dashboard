// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:guardian/utils/junit_xml/junit_xml.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

import '../test_utils/xml_string_builder_util.dart';
import '../test_utils/xml_string_parse_util.dart';

void main() {
  group('TestSuiteParser', () {
    final parser = TestSuiteParser();

    XmlElement twoSystemOutElement;
    XmlElement twoSystemErrElement;
    XmlElement twoPropertiesElement;
    XmlElement invalidElement;
    XmlElement validElement;

    setUpAll(() {
      const testSuiteAttributes = 'name="RandomClass" tests="1" errors="0" '
          'failures="0" time="0.123" hostname="localhost"';

      twoSystemOutElement = XmlStringParseUtil.parseXml(
        XmlStringBuilderUtil.duplicateNodeXml(
          'testcase',
          'system-out',
          testSuiteAttributes,
        ),
      );

      twoSystemErrElement = XmlStringParseUtil.parseXml(
        XmlStringBuilderUtil.duplicateNodeXml(
          'testsuite',
          'system-err',
          testSuiteAttributes,
        ),
      );

      twoPropertiesElement = XmlStringParseUtil.parseXml(
        XmlStringBuilderUtil.duplicateNodeXml(
          'testsuite',
          'properties',
          testSuiteAttributes,
        ),
      );

      invalidElement = XmlStringParseUtil.parseXml(
        XmlStringBuilderUtil.emptyNodeXml('testsuite'),
      );

      validElement = XmlStringParseUtil.parseXml('''
        <?xml version='1.0' encoding='UTF-8'?>
        <testsuite $testSuiteAttributes>
          <testcase name="randomTestCase()" classname="RandomClass" time="0.123"/>
        </testsuite>
      ''');
    });

    test(
      "validate() returns false if <testsuite> element contains more than one <system-out> elements",
      () {
        final result = parser.validate(twoSystemOutElement);

        expect(result, isFalse);
      },
    );

    test(
      "validate() returns false if <testsuite> element contains more than one <system-err> elements",
      () {
        final result = parser.validate(twoSystemErrElement);

        expect(result, isFalse);
      },
    );

    test(
      "validate() returns false if <testsuite> element contains more than one <properties> elements",
      () {
        final result = parser.validate(twoPropertiesElement);

        expect(result, isFalse);
      },
    );

    test("validate() returns false on missing required attribute(s)", () {
      final result = parser.validate(invalidElement);

      expect(result, isFalse);
    });

    test("validate() returns true on valid <testsuite> element", () {
      final result = parser.validate(validElement);

      expect(result, isTrue);
    });

    test("mapElement() maps <testsuite> element", () {
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

      final result = parser.mapElement(validElement);

      expect(result, equals(expected));
    });
  });
}
