// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:guardian/utils/junit_xml/junit_xml.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

import '../test_utils/xml_string_builder_util.dart';
import '../test_utils/xml_string_parse_util.dart';

void main() {
  group('PropertiesParser', () {
    final parser = PropertiesParser();

    XmlElement propertiesElement;

    setUpAll(() {
      propertiesElement = XmlStringParseUtil.parseXml('''
        <?xml version='1.0' encoding='UTF-8'?>
        <properties>
          <property name="var1" value="1"/>
          <property name="var2" value="2"/>
        </properties>
      ''');
    });

    test("mapElement() maps a list of properties", () {
      const expected = [
        JUnitProperty(name: 'var1', value: '1'),
        JUnitProperty(name: 'var2', value: '2'),
      ];

      final result = parser.mapElement(propertiesElement);

      expect(result, equals(expected));
    });
  });

  group('PropertyParser', () {
    final parser = PropertyParser();

    XmlElement emptyPropertyElement;
    XmlElement propertyElement;

    setUpAll(() {
      emptyPropertyElement = XmlStringParseUtil.parseXml(
        XmlStringBuilderUtil.emptyNodeXml('property'),
      );

      propertyElement = XmlStringParseUtil.parseXml('''
        <?xml version='1.0' encoding='UTF-8'?>
        <property name="var1" value="1"/>
      ''');
    });

    test("validate() returns false on missing required attribute(s)", () {
      final result = parser.validate(emptyPropertyElement);

      expect(result, isFalse);
    });

    test("validate() returns true on valid <property> element", () {
      final result = parser.validate(propertyElement);

      expect(result, isTrue);
    });

    test("mapElement() maps <property> element", () {
      const expected = JUnitProperty(name: 'var1', value: '1');

      final result = parser.mapElement(propertyElement);

      expect(result, equals(expected));
    });
  });
}
