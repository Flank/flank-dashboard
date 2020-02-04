part of junit_xml;

/// A [JUnitTestCase] node parser.
class TestCaseParser extends XmlElementParser<JUnitTestCase> {
  @override
  String get elementName => 'testcase';

  @override
  JUnitTestCase mapElement(xml.XmlElement xmlElement) {
    final valuesMap = getAttributes(xmlElement);

    return JUnitTestCase(
      name: valuesMap['name'],
      classname: valuesMap['classname'],
      assertions: IntAttributeValueParser().tryParse(valuesMap['assertions']),
      time: DoubleAttributeValueParser().tryParse(valuesMap['time']),
      failures: parseChildren(TestCaseFailureParser(), xmlElement),
      errors: parseChildren(TestCaseErrorParser(), xmlElement),
      skipped: parseChild(TestCaseSkippedParser(), xmlElement),
      systemOut: parseChild(SystemOutParser(), xmlElement),
      systemErr: parseChild(SystemErrParser(), xmlElement),
    );
  }

  @override
  bool validate(xml.XmlElement xmlElement) {
    final systemOutSingle = countChildren(SystemOutParser(), xmlElement) <= 1;
    final systemErrSingle = countChildren(SystemErrParser(), xmlElement) <= 1;

    return systemOutSingle && systemErrSingle;
  }
}
