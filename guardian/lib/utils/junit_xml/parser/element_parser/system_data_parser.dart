part of junit_xml;

/// A [JUnitSystemOutData] node parser.
class SystemOutParser extends XmlElementParser<JUnitSystemOutData> {
  @override
  String get elementName => 'system-out';

  @override
  JUnitSystemOutData _parse(xml.XmlElement xmlElement) {
    return JUnitSystemOutData(text: xmlElement.text);
  }
}

/// A [JUnitSystemErrData] node parser.
class SystemErrParser extends XmlElementParser<JUnitSystemErrData> {
  @override
  String get elementName => 'system-err';

  @override
  JUnitSystemErrData _parse(xml.XmlElement xmlElement) {
    return JUnitSystemErrData(text: xmlElement.text);
  }
}
