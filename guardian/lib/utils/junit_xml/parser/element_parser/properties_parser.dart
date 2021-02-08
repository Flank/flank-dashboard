// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

part of junit_xml;

/// A <properties> ([JUnitTestSuite.properties]) node parser.
class PropertiesParser extends XmlElementParser<List<JUnitProperty>> {
  @override
  String get elementName => 'properties';

  @override
  List<JUnitProperty> mapElement(xml.XmlElement xmlElement) {
    return parseChildren(PropertyParser(), xmlElement);
  }
}

/// A [JUnitProperty] node parser.
class PropertyParser extends XmlElementParser<JUnitProperty> {
  @override
  String get elementName => 'property';

  @override
  JUnitProperty mapElement(xml.XmlElement xmlElement) {
    final valuesMap = getAttributes(xmlElement);

    return JUnitProperty(
      name: ValueParsers.string.parse(valuesMap['name']),
      value: ValueParsers.string.parse(valuesMap['value']),
    );
  }

  @override
  bool validate(xml.XmlElement xmlElement) {
    return checkAttributes(xmlElement, {
      'name': ValueParsers.string,
      'value': ValueParsers.string,
    });
  }
}
