part of junit_xml;

class PropertiesParser extends XmlElementParser<List<JUnitProperty>> {
  @override
  String get elementName => 'properties';

  @override
  List<JUnitProperty> _parse(xml.XmlElement xmlElement) {
    return parseChildren(PropertyParser(), xmlElement);
  }

  @override
  bool validate(xml.XmlElement xmlElement) {
    return true;
  }
}

class PropertyParser extends XmlElementParser<JUnitProperty> {
  @override
  String get elementName => 'property';

  @override
  JUnitProperty _parse(xml.XmlElement xmlElement) {
    final valuesMap = getAttributes(xmlElement);

    return JUnitProperty(
      name: valuesMap['name'],
      value: valuesMap['value'],
    );
  }

  @override
  bool validate(xml.XmlElement xmlElement) {
    return hasNonNullAttributes(xmlElement, ['name', 'value']);
  }
}
