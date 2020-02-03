part of junit_xml;

/// A [JUnitTestSuites] node parser.
class TestSuitesParser extends XmlElementParser<JUnitTestSuites> {
  @override
  String get elementName => 'testsuites';

  @override
  JUnitTestSuites _parse(xml.XmlElement xmlElement) {
    final valuesMap = getAttributes(xmlElement);

    return JUnitTestSuites(
      name: valuesMap['name'],
      disabled: IntAttributeValueParser().tryParse(valuesMap['disabled']),
      failures: IntAttributeValueParser().tryParse(valuesMap['failures']),
      errors: IntAttributeValueParser().tryParse(valuesMap['errors']),
      tests: IntAttributeValueParser().tryParse(valuesMap['tests']),
      time: DoubleAttributeValueParser().tryParse(valuesMap['time']),
      testSuites: parseChildren<JUnitTestSuite>(TestSuiteParser(), xmlElement),
    );
  }
}
