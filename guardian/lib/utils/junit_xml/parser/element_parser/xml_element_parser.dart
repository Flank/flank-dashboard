// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

part of junit_xml;

/// An XML node parser abstract class that defines parse methods for
/// specified type [T].
abstract class XmlElementParser<T> {
  /// A node name this parser is able to parse.
  String get elementName;

  /// Parses [xmlElement] into specified type [T].
  ///
  /// Throws [ArgumentError] if element name is not equal to [elementName].
  /// Throws [FormatException] if element is invalid.
  @nonVirtual
  T parse(xml.XmlElement xmlElement) {
    if (xmlElement.name.local != elementName) {
      throw ArgumentError('Xml elemnt name does not match format name');
    }

    if (validate(xmlElement)) {
      return mapElement(xmlElement);
    } else {
      throw FormatException(
        'XML element is invalid:\n'
        '${xmlElement.name.qualified} at ${xmlElement.depth} depth level',
      );
    }
  }

  /// Maps [xmlElement] into specified type [T].
  @visibleForOverriding
  @visibleForTesting
  T mapElement(xml.XmlElement xmlElement);

  /// Validates [xmlElement].
  ///
  /// Returns true by default - implementations can change this behavior
  /// according to their needs.
  bool validate(xml.XmlElement xmlElement) => true;

  /// Counts nested nodes of [xmlElement] with name specified
  /// by [parser.elementName].
  @nonVirtual
  int countChildren(
    XmlElementParser parser,
    xml.XmlElement xmlElement,
  ) {
    return xmlElement.findAllElements(parser.elementName).length;
  }

  /// Delegates parsing of nested nodes of [xmlElement] to [parser].
  @nonVirtual
  List<E> parseChildren<E>(
    XmlElementParser<E> parser,
    xml.XmlElement xmlElement,
  ) {
    return xmlElement
        .findAllElements(parser.elementName)
        .map((element) => parser.parse(element))
        .toList();
  }

  /// Delegates parsing of single nested node of [xmlElement] to [parser].
  @nonVirtual
  E parseChild<E>(
    XmlElementParser<E> parser,
    xml.XmlElement xmlElement,
  ) {
    final result = parseChildren<E>(parser, xmlElement);
    return result.isEmpty ? null : result.single;
  }

  /// Retrieves all attributes of [xmlElement] - their names and values -
  /// into [Map].
  @nonVirtual
  Map<String, String> getAttributes(xml.XmlElement xmlElement) {
    return {for (var a in xmlElement.attributes) a.name.local: a.value};
  }

  /// Checks attributes of [xmlElement] specified by [names] map keys to
  /// be presented and valid to parse.
  @nonVirtual
  bool checkAttributes(
    xml.XmlElement xmlElement,
    Map<String, XmlAttributeValueParser> names,
  ) {
    return names != null &&
        names.entries.every((entity) {
          final name = entity.key;
          final parser = entity.value;

          final attribute = xmlElement.getAttributeNode(name);

          return attribute != null &&
              attribute.value != null &&
              parser.canParse(attribute.value);
        });
  }
}
