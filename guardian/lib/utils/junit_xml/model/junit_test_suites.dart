// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

part of junit_xml;

/// A class representing <testsuites> element of JUnitXML report.
///
/// If only a single <testsuite> ([JUnitTestSuite]) element is present, this
/// element can be omitted in the report but in order to maintain same structure
/// for all reports - assume this to be required element.
/// All properties are optional.
class JUnitTestSuites extends Equatable {
  final String name;

  /// Total number of disabled tests from all test suites.
  final int disabled;

  /// Total number of tests with error result from all test suites.
  final int errors;

  /// Total number of failed tests from all test suites.
  final int failures;

  /// Total number of tests from all test suites.
  final int tests;

  /// Time in seconds to execute all test suites.
  final double time;

  /// Test suites list presented in the report.
  final List<JUnitTestSuite> testSuites;

  const JUnitTestSuites({
    @required this.testSuites,
    this.name,
    this.disabled,
    this.errors,
    this.failures,
    this.tests,
    this.time,
  });

  @override
  List<Object> get props => [
        name,
        disabled,
        errors,
        failures,
        tests,
        time,
        testSuites,
      ];

  @override
  String toString() {
    return '$props';
  }
}
