// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

part of junit_xml;

/// A [JUnitTestSuites] node parser.
class TestSuitesParser extends XmlElementParser<JUnitTestSuites> {
  @override
  String get elementName => 'testsuites';

  @override
  JUnitTestSuites mapElement(xml.XmlElement xmlElement) {
    final valuesMap = getAttributes(xmlElement);

    return JUnitTestSuites(
      name: ValueParsers.string.tryParse(valuesMap['name']),
      disabled: ValueParsers.int.tryParse(valuesMap['disabled']),
      failures: ValueParsers.int.tryParse(valuesMap['failures']),
      errors: ValueParsers.int.tryParse(valuesMap['errors']),
      tests: ValueParsers.int.tryParse(valuesMap['tests']),
      time: ValueParsers.double.tryParse(valuesMap['time']),
      testSuites: parseChildren<JUnitTestSuite>(TestSuiteParser(), xmlElement),
    );
  }
}
