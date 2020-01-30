part of junit_xml;

class Testsuite extends JunitXmlReportRoot {
  final int id;
  final String name;
  final int tests;
  final int disabled;
  final int errors;
  final int failures;
  final int skipped;
  final double time;
  final DateTime timestamp;
  final String hostname;
  final String package;
  final List<Property> properties;
  final List<Testcase> testcases;
  final SystemOutData systemOut;
  final SystemErrData systemErr;

  Testsuite({
    @required this.name,
    @required this.tests,
    this.id,
    this.disabled,
    this.errors,
    this.failures,
    this.skipped,
    this.time,
    this.timestamp,
    this.hostname = 'localhost',
    this.package,
    this.properties,
    this.testcases,
    this.systemOut,
    this.systemErr,
  });
}
