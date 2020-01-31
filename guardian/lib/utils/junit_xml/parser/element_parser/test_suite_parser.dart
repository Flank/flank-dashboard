part of junit_xml;

class TestSuiteParser extends XmlElementParser<JUnitTestSuite> {
  @override
  String get elementName => 'testsuite';

  @override
  JUnitTestSuite _parse(xml.XmlElement xmlElement) {
    final valuesMap = getAttributes(xmlElement);

    return JUnitTestSuite(
      name: valuesMap['name'],
      tests: int.tryParse(valuesMap['tests']),
      id: valuesMap['id'] != null ? int.tryParse(valuesMap['id']) : null,
      disabled: valuesMap['disabled'] != null
          ? int.tryParse(valuesMap['disabled'])
          : null,
      failures: valuesMap['failures'] != null
          ? int.tryParse(valuesMap['failures'])
          : null,
      errors: valuesMap['errors'] != null
          ? int.tryParse(valuesMap['errors'])
          : null,
      skipped: valuesMap['skipped'] != null
          ? int.tryParse(valuesMap['skipped'])
          : null,
      time:
          valuesMap['time'] != null ? double.tryParse(valuesMap['time']) : null,
      timestamp: valuesMap['timestamp'] != null
          ? DateTime.tryParse(valuesMap['timestamp'])
          : null,
      hostname: valuesMap['hostname'],
      package: valuesMap['package'],
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
        hasNonNullAttributes(xmlElement, ['name', 'tests']);
  }
}
