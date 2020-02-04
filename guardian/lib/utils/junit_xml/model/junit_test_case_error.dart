part of junit_xml;

/// A class representing <error> element of JUnitXML report.
///
/// [text] contains relevant data for the error (for example, a stack trace).
class JUnitTestCaseError extends JUnitTestCaseExecutionResult {
  const JUnitTestCaseError({String text}) : super(text: text);
}