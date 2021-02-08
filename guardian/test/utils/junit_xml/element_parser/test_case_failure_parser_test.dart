// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:guardian/utils/junit_xml/junit_xml.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

import '../test_utils/xml_string_builder_util.dart';
import '../test_utils/xml_string_parse_util.dart';

void main() {
  group('TestCaseFailureParser', () {
    const text = 'Test case failure';

    final parser = TestCaseFailureParser();

    XmlElement element;

    setUpAll(() {
      element = XmlStringParseUtil.parseXml(
        XmlStringBuilderUtil.textNodeXml('failure', text),
      );
    });

    test("mapElement() maps <failure> element", () {
      const expected = JUnitTestCaseFailure(text: text);

      final result = parser.mapElement(element);

      expect(result, equals(expected));
    });
  });
}
