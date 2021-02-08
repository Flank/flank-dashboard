// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

part of junit_xml;

/// A class representing <skipped> element of JUnitXML report.
///
/// [text] contains description why the test case was skipped.
class JUnitTestCaseSkipped extends JUnitTestCaseExecutionResult {
  const JUnitTestCaseSkipped({String text}) : super(text: text);
}
