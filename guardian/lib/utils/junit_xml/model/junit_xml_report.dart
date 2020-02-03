part of junit_xml;

/// A class representing JUnitXML report.
class JUnitXmlReport {
  final JUnitTestSuites testSuites;

  JUnitXmlReport(this.testSuites);

  @override
  String toString() {
    return 'JUnitXmlReport { testSuites = $testSuites }';
  }
}
