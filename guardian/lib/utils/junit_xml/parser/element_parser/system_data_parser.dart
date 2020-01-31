part of junit_xml;

class SystemOutParser extends XmlElementParser<JUnitSystemOutData> {
  @override
  String get elementName => 'system-out';

  @override
  JUnitSystemOutData _parse(xml.XmlElement xmlElement) {
    return JUnitSystemOutData(text: xmlElement.text);
  }

  @override
  bool validate(xml.XmlElement xmlElement) {
    return true;
  }
}

class SystemErrParser extends XmlElementParser<JUnitSystemErrData> {
  @override
  String get elementName => 'system-err';

  @override
  JUnitSystemErrData _parse(xml.XmlElement xmlElement) {
    return JUnitSystemErrData(text: xmlElement.text);
  }

  @override
  bool validate(xml.XmlElement xmlElement) {
    return true;
  }
}
