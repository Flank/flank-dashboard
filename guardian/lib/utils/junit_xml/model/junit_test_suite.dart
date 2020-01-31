part of junit_xml;

class JUnitTestSuite {
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
  final List<JUnitProperty> properties;
  final List<JUnitTestCase> testCases;
  final JUnitSystemOutData systemOut;
  final JUnitSystemErrData systemErr;

  JUnitTestSuite({
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
    this.testCases,
    this.systemOut,
    this.systemErr,
  });

  @override
  String toString() {
    return 'TestSuite {'
        'name = $name, \n'
        'tests = $tests, \n'
        'id = $id, \n'
        'disabled = $disabled, \n'
        'errors = $errors, \n'
        'failures = $failures, \n'
        'skipped = $skipped, \n'
        'time = $time, \n'
        'timestamp = $timestamp, \n'
        'hostname = $hostname, \n'
        'package = $package, \n'
        'properties = $properties, \n'
        'testcases = $testCases, \n'
        'systemOut = $systemOut, \n'
        'systemErr = $systemErr \n}';
  }
}
