// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:guardian/utils/junit_xml/junit_xml.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

import '../test_utils/xml_string_builder_util.dart';
import '../test_utils/xml_string_parse_util.dart';

void main() {
  group('TestCaseParser', () {
    final parser = TestCaseParser();

    XmlElement twoSystemOutElement;
    XmlElement twoSystemErrElement;
    XmlElement emptyElement;
    XmlElement validElement;

    setUpAll(() {
      twoSystemOutElement = XmlStringParseUtil.parseXml(
        XmlStringBuilderUtil.duplicateNodeXml('testcase', 'system-out'),
      );

      twoSystemErrElement = XmlStringParseUtil.parseXml(
        XmlStringBuilderUtil.duplicateNodeXml('testcase', 'system-err'),
      );

      emptyElement = XmlStringParseUtil.parseXml(
        XmlStringBuilderUtil.emptyNodeXml('testcase'),
      );

      validElement = XmlStringParseUtil.parseXml('''
        <?xml version='1.0' encoding='UTF-8'?>
        <testcase name="randomTestCase()" classname="RandomClass" time="0.123">
          <failure>Exception: RandomException</failure>
          <failure>Random stack trace</failure>
          <system-out/>
          <system-err>Error occurred</system-err>
        </testcase>
      ''');
    });

    test(
      "validate() returns false if <testcase> element contains more than one <system-out> elements",
      () {
        final result = parser.validate(twoSystemOutElement);

        expect(result, isFalse);
      },
    );

    test(
      "validate() returns false if <testcase> element contains more than one <system-err> elements",
      () {
        final result = parser.validate(twoSystemErrElement);

        expect(result, isFalse);
      },
    );

    test("validate() returns true on valid <testcase> element", () {
      final result = parser.validate(validElement);

      expect(result, isTrue);
    });

    test("mapElement() maps an empty <testcase/> element", () {
      final result = parser.mapElement(emptyElement);

      expect(result, equals(const JUnitTestCase()));
    });

    test("mapElement() maps <testcase> element", () {
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

      final result = parser.mapElement(validElement);

      expect(result, equals(expected));
    });
  });
}
