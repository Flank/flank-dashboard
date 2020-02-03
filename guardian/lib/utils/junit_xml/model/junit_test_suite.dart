part of junit_xml;

/// A class representing <testsuite> element of JUnitXML report.
///
/// [name], [tests], [errors], [failures], [time] and [hostname] are required.
class JUnitTestSuite {
  /// Full (class) name of the test for non-aggregated testsuite documents.
  /// Class name without the package for aggregated testsuite documents.
  final String name;

  /// The total number of tests in the suite.
  final int tests;

  /// The total number of disabled tests in the suite.
  final int disabled;

  /// The total number of tests in the suite that errored.
  final int errors;

  /// The total number of tests in the suite that failed.
  final int failures;

  /// The total number of skipped tests.
  final int skipped;

  /// Time taken (in seconds) to execute the tests in the suite.
  final double time;

  /// When the test was executed in ISO 8601 format.
  final DateTime timestamp;

  /// Host on which the tests were executed.
  final String hostname;

  /// Execution ID of Firebase Test Lab.
  final String testLabExecutionId;

  /// Properties (e.g., environment settings) set during test.
  final List<JUnitProperty> properties;

  /// Tests executed in the suite.
  final List<JUnitTestCase> testCases;

  /// Data that was written to standard out while the test suite was executed.
  final JUnitSystemOutData systemOut;

  /// Data that was written to standard error while the test suite was executed.
  final JUnitSystemErrData systemErr;

  JUnitTestSuite({
    @required this.name,
    @required this.tests,
    @required this.errors,
    @required this.failures,
    @required this.time,
    @required this.hostname,
    this.disabled,
    this.skipped,
    this.timestamp,
    this.properties,
    this.testCases,
    this.systemOut,
    this.systemErr,
    this.testLabExecutionId,
  });

  @override
  String toString() {
    return 'TestSuite {'
        'name = $name, \n'
        'tests = $tests, \n'
        'disabled = $disabled, \n'
        'errors = $errors, \n'
        'failures = $failures, \n'
        'skipped = $skipped, \n'
        'time = $time, \n'
        'timestamp = $timestamp, \n'
        'hostname = $hostname, \n'
        'properties = $properties, \n'
        'testcases = $testCases, \n'
        'systemOut = $systemOut, \n'
        'systemErr = $systemErr \n}';
  }
}
