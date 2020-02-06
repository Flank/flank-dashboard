part of junit_xml;

/// A class representing JUnitXML report.
class JUnitXmlReport extends Equatable {
  final JUnitTestSuites testSuites;

  const JUnitXmlReport(this.testSuites);

  @override
  List<Object> get props => [testSuites];
}
