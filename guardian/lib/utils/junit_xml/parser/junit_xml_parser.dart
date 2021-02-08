// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

part of junit_xml;

/// A utility class providing method for validating and parsing JUnitXML report
/// and its content into [JUnitXmlReport].
///
/// Example:
/// ```dart
///   const parser = JUnitXmlParser();
///   final file = File('junit.xml');
///   final JUnitXmlReport report = parser.parse(file.readAsStringSync());
/// ```
class JUnitXmlParser {
  const JUnitXmlParser();

  /// Parses JUnitXML string into [JUnitXmlReport].
  ///
  /// Throws [ArgumentError] if [xmlString] is `null` or is not JUnitXML report.
  /// Throws [xml.XmlException] if XML direct parsing is failed.
  /// Throws [FormatException] if validation for JUnit report nodes is failed.
  JUnitXmlReport parse(String xmlString) {
    if (xmlString == null) {
      throw ArgumentError('The XML is not allowed to be null.');
    }

    final xmlDocument = xml.parse(xmlString);
    final _testSuitesParser = TestSuitesParser();
    final _testSuiteParser = TestSuiteParser();
    final rootElement = xmlDocument.rootElement;

    JUnitTestSuites testSuites;

    if (rootElement.name.local == _testSuitesParser.elementName) {
      testSuites = _testSuitesParser.parse(rootElement);
    } else if (rootElement.name.local == _testSuiteParser.elementName) {
      testSuites = JUnitTestSuites(testSuites: [
        _testSuiteParser.parse(rootElement),
      ]);
    } else {
      throw ArgumentError(
        'The XML is not JUnit report. Root element should be one of '
        '[<${_testSuitesParser.elementName}>, <${_testSuiteParser.elementName}>]',
      );
    }

    return JUnitXmlReport(testSuites);
  }
}
