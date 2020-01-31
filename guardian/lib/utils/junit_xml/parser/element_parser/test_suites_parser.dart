part of junit_xml;

class TestSuitesParser extends XmlElementParser<JUnitTestSuites> {
  @override
  String get elementName => 'testsuites';

  @override
  JUnitTestSuites _parse(xml.XmlElement xmlElement) {
    final valuesMap = getAttributes(xmlElement);

    return JUnitTestSuites(
      name: valuesMap['name'],
      disabled: valuesMap['disabled'] != null
          ? int.tryParse(valuesMap['disabled'])
          : null,
      failures: valuesMap['failures'] != null
          ? int.tryParse(valuesMap['failures'])
          : null,
      errors: valuesMap['errors'] != null
          ? int.tryParse(valuesMap['errors'])
          : null,
      tests:
          valuesMap['tests'] != null ? int.tryParse(valuesMap['tests']) : null,
      time:
          valuesMap['time'] != null ? double.tryParse(valuesMap['time']) : null,
      testSuites: parseChildren<JUnitTestSuite>(TestSuiteParser(), xmlElement),
    );
  }

  @override
  bool validate(xml.XmlElement xmlElement) {
    return true;
  }
}
