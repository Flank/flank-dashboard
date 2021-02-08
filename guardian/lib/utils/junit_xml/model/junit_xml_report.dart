// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

part of junit_xml;

/// A class representing JUnitXML report.
class JUnitXmlReport extends Equatable {
  final JUnitTestSuites testSuites;

  const JUnitXmlReport(this.testSuites);

  @override
  List<Object> get props => [testSuites];
}
