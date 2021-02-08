// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

part of junit_xml;

/// A [JUnitTestCase] node parser.
class TestCaseParser extends XmlElementParser<JUnitTestCase> {
  @override
  String get elementName => 'testcase';

  @override
  JUnitTestCase mapElement(xml.XmlElement xmlElement) {
    final valuesMap = getAttributes(xmlElement);

    return JUnitTestCase(
      name: ValueParsers.string.tryParse(valuesMap['name']),
      classname: ValueParsers.string.tryParse(valuesMap['classname']),
      assertions: ValueParsers.int.tryParse(valuesMap['assertions']),
      time: ValueParsers.double.tryParse(valuesMap['time']),
      flaky: ValueParsers.bool.tryParse(valuesMap['flaky']),
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
