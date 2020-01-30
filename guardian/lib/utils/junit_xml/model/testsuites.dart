part of junit_xml;

class Testsuites extends JunitXmlReportRoot {
  final String name;
  final int disabled;
  final int errors;
  final int failures;
  final int tests;
  final double time;
  final List<Testsuite> testsuites;

  Testsuites({
    @required this.testsuites,
    this.name,
    this.disabled,
    this.errors,
    this.failures,
    this.tests,
    this.time,
  });
}
