part of junit_xml;

/// A class representing <skipped> element of JUnitXML report.
///
/// [text] contains description why the test case was skipped.
class JUnitTestCaseSkipped extends JUnitTestCaseExecutionResult {
  JUnitTestCaseSkipped({String text}) : super(text: text);
}