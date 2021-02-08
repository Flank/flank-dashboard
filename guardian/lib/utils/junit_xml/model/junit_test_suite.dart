// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

part of junit_xml;

/// A class representing <testsuite> element of JUnitXML report.
///
/// [name], [tests], [errors], [failures], [time] and [hostname] are required.
class JUnitTestSuite extends Equatable {
  /// Full (class) name of the test for non-aggregated testsuite documents.
  /// Class name without the package for aggregated testsuite documents.
  final String name;

  /// The total number of tests in the suite.
  final int tests;

  /// The total number of disabled tests in the suite.
  final int disabled;

  /// The total number of tests in the suite that errored.
  final int errors;

  /// The total number of flaky tests in the suite.
  final int flakes;

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

  const JUnitTestSuite({
    @required this.name,
    @required this.tests,
    @required this.errors,
    @required this.failures,
    @required this.time,
    @required this.hostname,
    this.flakes,
    this.disabled,
    this.skipped,
    this.timestamp,
    this.properties,
    this.testCases = const [],
    this.systemOut,
    this.systemErr,
    this.testLabExecutionId,
  });

  @override
  List<Object> get props => [
        name,
        tests,
        disabled,
        errors,
        flakes,
        failures,
        skipped,
        time,
        timestamp,
        hostname,
        testLabExecutionId,
        properties,
        testCases,
        systemOut,
        systemErr,
      ];

  @override
  String toString() {
    return '$runtimeType $props';
  }
}
