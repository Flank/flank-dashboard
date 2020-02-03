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
  /// Throws [ArgumentError] if [xmlString] is null or is not JUnitXML report.
  /// Throws [xml.XmlException] if XML direct parsing is failed.
  /// Throws [FormatException] if validation for JUnit report nodes is failed.
  JUnitXmlReport parse(String xmlString) {
    if (xmlString == null) {
      throw ArgumentError('The XML is not allowed to be null.');
    }

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
      throw ArgumentError('The XML is not JUnit report.');
    }

    return JUnitXmlReport(testSuites);
  }
}
