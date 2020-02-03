part of junit_xml;

/// A [JUnitTestSuite] node parser.
class TestSuiteParser extends XmlElementParser<JUnitTestSuite> {
  @override
  String get elementName => 'testsuite';

  @override
  JUnitTestSuite _parse(xml.XmlElement xmlElement) {
    final valuesMap = getAttributes(xmlElement);

    return JUnitTestSuite(
      name: valuesMap['name'],
      tests: IntAttributeValueParser().parse(valuesMap['tests']),
      disabled: IntAttributeValueParser().tryParse(valuesMap['disabled']),
      failures: IntAttributeValueParser().parse(valuesMap['failures']),
      errors: IntAttributeValueParser().parse(valuesMap['errors']),
      skipped: IntAttributeValueParser().tryParse(valuesMap['skipped']),
      time: DoubleAttributeValueParser().parse(valuesMap['time']),
      timestamp: DateTimeAttributeValueParser().parse(valuesMap['timestamp']),
      hostname: valuesMap['hostname'],
      testLabExecutionId: valuesMap['testLabExecutionId'],
      properties: parseChild(PropertiesParser(), xmlElement),
      testCases: parseChildren(TestCaseParser(), xmlElement),
      systemOut: parseChild(SystemOutParser(), xmlElement),
      systemErr: parseChild(SystemErrParser(), xmlElement),
    );
  }

  @override
  bool validate(xml.XmlElement xmlElement) {
    final systemOutSingle = countChildren(SystemOutParser(), xmlElement) <= 1;
    final systemErrSingle = countChildren(SystemErrParser(), xmlElement) <= 1;
    final propertiesSingle = countChildren(PropertiesParser(), xmlElement) <= 1;

    return systemOutSingle &&
        systemErrSingle &&
        propertiesSingle &&
        checkAttributes(xmlElement, {
          'name': StringAttributeValueParser(),
          'tests': IntAttributeValueParser(),
          'errors': IntAttributeValueParser(),
          'failures': IntAttributeValueParser(),
          'time': DoubleAttributeValueParser(),
          'hostname': StringAttributeValueParser(),
        });
  }
}
