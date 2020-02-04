part of junit_xml;

/// A [JUnitSystemOutData] node parser.
class SystemOutParser extends XmlElementParser<JUnitSystemOutData> {
  @override
  String get elementName => 'system-out';

  @override
  JUnitSystemOutData mapElement(xml.XmlElement xmlElement) {
    return JUnitSystemOutData(text: xmlElement.text);
  }
}
