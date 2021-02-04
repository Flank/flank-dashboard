// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

part of junit_xml;

/// A [JUnitTestSuite] node parser.
class TestSuiteParser extends XmlElementParser<JUnitTestSuite> {
  @override
  String get elementName => 'testsuite';

  @override
  JUnitTestSuite mapElement(xml.XmlElement xmlElement) {
    final valuesMap = getAttributes(xmlElement);

    return JUnitTestSuite(
      name: ValueParsers.string.parse(valuesMap['name']),
      tests: ValueParsers.int.parse(valuesMap['tests']),
      disabled: ValueParsers.int.tryParse(valuesMap['disabled']),
      failures: ValueParsers.int.parse(valuesMap['failures']),
      errors: ValueParsers.int.parse(valuesMap['errors']),
      flakes: ValueParsers.int.tryParse(valuesMap['flakes']),
      skipped: ValueParsers.int.tryParse(valuesMap['skipped']),
      time: ValueParsers.double.parse(valuesMap['time']),
      timestamp: ValueParsers.dateTime.tryParse(valuesMap['timestamp']),
      hostname: ValueParsers.string.parse(valuesMap['hostname']),
      testLabExecutionId:
          ValueParsers.string.tryParse(valuesMap['testLabExecutionId']),
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
          'name': ValueParsers.string,
          'tests': ValueParsers.int,
          'errors': ValueParsers.int,
          'failures': ValueParsers.int,
          'time': ValueParsers.double,
          'hostname': ValueParsers.string,
        });
  }
}
