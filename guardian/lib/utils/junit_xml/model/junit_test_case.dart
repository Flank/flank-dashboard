// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

part of junit_xml;

/// A class representing <testcase> element of JUnitXML report.
///
/// [name], [classname] and [time] are always presented except for empty test
/// cases <testcase/>.
class JUnitTestCase extends Equatable {
  /// Name of the test method.
  final String name;

  /// Number of assertions in the test case.
  final int assertions;

  /// Full class name for the class the test method is in.
  final String classname;

  /// Time taken (in seconds) to execute the test.
  final double time;

  /// Flakiness of this test case.
  final bool flaky;

  /// List with all failure nodes of test case.
  ///
  /// <failure> node can appear multiple times.
  final List<JUnitTestCaseFailure> failures;

  /// List with all error nodes of test case.
  ///
  /// <error> node can appear multiple times.
  final List<JUnitTestCaseError> errors;

  /// Test skipped description.
  final JUnitTestCaseSkipped skipped;

  /// Data that was written to standard out while the test was executed.
  final JUnitSystemOutData systemOut;

  /// Data that was written to standard error while the test was executed.
  final JUnitSystemErrData systemErr;

  const JUnitTestCase({
    this.name,
    this.classname,
    this.assertions,
    this.time,
    this.flaky,
    this.failures = const [],
    this.errors = const [],
    this.skipped,
    this.systemOut,
    this.systemErr,
  });

  @override
  List<Object> get props => [
        name,
        assertions,
        classname,
        time,
        flaky,
        failures,
        errors,
        skipped,
        systemOut,
        systemErr,
      ];

  @override
  String toString() {
    return '$runtimeType $props';
  }
}
