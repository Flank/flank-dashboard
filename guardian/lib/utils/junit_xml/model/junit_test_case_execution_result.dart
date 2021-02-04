// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

part of junit_xml;

/// An abstract class representing test execution result.
abstract class JUnitTestCaseExecutionResult extends Equatable {
  final String text;

  const JUnitTestCaseExecutionResult({this.text});

  @override
  List<Object> get props => [text];
}
