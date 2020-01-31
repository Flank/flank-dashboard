part of junit_xml;

class JUnitTestSuites {
  final String name;
  final int disabled;
  final int errors;
  final int failures;
  final int tests;
  final double time;
  final List<JUnitTestSuite> testSuites;

  JUnitTestSuites({
    @required this.testSuites,
    this.name,
    this.disabled,
    this.errors,
    this.failures,
    this.tests,
    this.time,
  });
}
