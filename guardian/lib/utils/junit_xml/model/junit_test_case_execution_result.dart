part of junit_xml;

/// An abstract class representing test result.
abstract class JUnitTestCaseExecutionResult {
  final String text;

  JUnitTestCaseExecutionResult({this.text});
}

/// A class representing <error> element of JUnitXML report.
///
/// [text] contains relevant data for the error (for example, a stack trace).
class JUnitTestCaseError extends JUnitTestCaseExecutionResult {
  JUnitTestCaseError({String text}) : super(text: text);
}

/// A class representing <failure> element of JUnitXML report.
///
/// [text] contains relevant data for the failure (for example, a stack trace).
class JUnitTestCaseFailure extends JUnitTestCaseExecutionResult {
  JUnitTestCaseFailure({String text}) : super(text: text);
}

/// A class representing <skipped> element of JUnitXML report.
///
/// [text] contains description why the test case was skipped.
class JUnitTestCaseSkipped extends JUnitTestCaseExecutionResult {
  JUnitTestCaseSkipped({String text}) : super(text: text);
}
