// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:guardian/utils/junit_xml/junit_xml.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

import '../test_utils/xml_string_builder_util.dart';
import '../test_utils/xml_string_parse_util.dart';

void main() {
  group('TestCaseErrorParser', () {
    const text = 'Test case error';

    final parser = TestCaseErrorParser();

    XmlElement element;

    setUpAll(() {
      element = XmlStringParseUtil.parseXml(
        XmlStringBuilderUtil.textNodeXml('error', text),
      );
    });

    test("mapElement() maps <error> element", () {
      const expected = JUnitTestCaseError(text: text);

      final result = parser.mapElement(element);

      expect(result, equals(expected));
    });
  });
}
