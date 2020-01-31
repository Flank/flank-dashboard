part of junit_xml;

class TestCaseParser extends XmlElementParser<JUnitTestCase> {
  @override
  String get elementName => 'testcase';

  @override
  JUnitTestCase _parse(xml.XmlElement xmlElement) {
    final valuesMap = getAttributes(xmlElement);

    return JUnitTestCase(
      name: valuesMap['name'],
      classname: valuesMap['name'],
      assertions: valuesMap['assertions'] != null
          ? int.tryParse(valuesMap['assertions'])
          : null,
      status: valuesMap['status'],
      time:
          valuesMap['time'] != null ? double.tryParse(valuesMap['time']) : null,
      results: [
        ...parseChildren(TestCaseSkippedParser(), xmlElement),
        ...parseChildren(TestCaseErrorParser(), xmlElement),
        ...parseChildren(TestCaseFailureParser(), xmlElement),
      ],
      systemOut: parseChild(SystemOutParser(), xmlElement),
      systemErr: parseChild(SystemErrParser(), xmlElement),
    );
  }

  @override
  bool validate(xml.XmlElement xmlElement) {
    final systemOutSingle = countChildren(SystemOutParser(), xmlElement) <= 1;
    final systemErrSingle = countChildren(SystemErrParser(), xmlElement) <= 1;

    return systemOutSingle &&
        systemErrSingle &&
        hasNonNullAttributes(xmlElement, ['name', 'classname']);
  }
}
