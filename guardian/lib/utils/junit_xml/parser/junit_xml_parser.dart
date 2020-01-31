part of junit_xml;

class JUnitXmlParser {
  JUnitXmlReport parse(String xmlString) {
    final xmlDocument = xml.parse(xmlString);
    final _testSuitesFormat = TestSuitesParser();
    final _testSuiteFormat = TestSuiteParser();
    final rootElement = xmlDocument.rootElement;

    JUnitTestSuites testSuites;

    if (rootElement.name.local == _testSuitesFormat.elementName) {
      testSuites = _testSuitesFormat.parseIfValid(rootElement);
    } else if (rootElement.name.local == _testSuiteFormat.elementName) {
      testSuites = JUnitTestSuites(testSuites: [
        _testSuiteFormat.parseIfValid(rootElement),
      ]);
    } else {
      throw const FormatException();
    }

    print(testSuites);

    return JUnitXmlReport(testSuites);
  }
}
