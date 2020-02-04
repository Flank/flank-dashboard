part of junit_xml;

/// A [JUnitSystemErrData] node parser.
class SystemErrParser extends XmlElementParser<JUnitSystemErrData> {
  @override
  String get elementName => 'system-err';

  @override
  JUnitSystemErrData mapElement(xml.XmlElement xmlElement) {
    return JUnitSystemErrData(text: xmlElement.text);
  }
}
