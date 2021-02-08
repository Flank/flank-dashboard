// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

part of junit_xml;

/// A class representing <failure> element of JUnitXML report.
///
/// [text] contains relevant data for the failure (for example, a stack trace).
class JUnitTestCaseFailure extends JUnitTestCaseExecutionResult {
  const JUnitTestCaseFailure({String text}) : super(text: text);
}
