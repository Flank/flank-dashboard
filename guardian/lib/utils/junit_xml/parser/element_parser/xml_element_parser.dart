part of junit_xml;

abstract class XmlElementParser<T> {
  String get elementName;

  T parseIfValid(xml.XmlElement xmlElement) {
    if (xmlElement.name.local != elementName) {
      throw ArgumentError('Xml elemnt name does not match format name');
    }

    if (validate(xmlElement)) {
      return _parse(xmlElement);
    } else {
      throw FormatException(
        'XML element is invalid:\n'
        '${xmlElement.name.qualified} at ${xmlElement.depth} depth level',
      );
    }
  }

  T _parse(xml.XmlElement xmlElement);

  bool validate(xml.XmlElement xmlElement);

  int countChildren(
    XmlElementParser parser,
    xml.XmlElement xmlElement,
  ) {
    return xmlElement.findAllElements(parser.elementName).length;
  }

  List<E> parseChildren<E>(
    XmlElementParser<E> parser,
    xml.XmlElement xmlElement,
  ) {
    return xmlElement
        .findAllElements(parser.elementName)
        .map((element) => parser.parseIfValid(element))
        .toList();
  }

  E parseChild<E>(
    XmlElementParser<E> parser,
    xml.XmlElement xmlElement,
  ) {
    final result = xmlElement
        .findAllElements(parser.elementName)
        .map((element) => parser.parseIfValid(element));
    return result.isEmpty ? null : result.first;
  }

  Map<String, String> getAttributes(xml.XmlElement xmlElement) {
    return {for (var a in xmlElement.attributes) a.name.local: a.value};
  }

  Map<String, String> getAttributesValuesByNames(
    xml.XmlElement xmlElement,
    List<String> names,
  ) {
    final values = names.map(xmlElement.getAttribute);
    return Map<String, String>.fromIterables(names, values);
  }

  bool hasNonNullAttributes(
    xml.XmlElement xmlElement,
    List<String> names,
  ) {
    if (names == null) return false;

    return names?.every((name) {
      final attribute = xmlElement.getAttributeNode(name);
      return attribute != null && attribute.value != null;
    });
  }
}
