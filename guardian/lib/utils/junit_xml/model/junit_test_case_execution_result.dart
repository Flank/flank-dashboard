part of junit_xml;

abstract class JUnitTestCaseExecutionResult {
  final String text;

  JUnitTestCaseExecutionResult({this.text});
}

class JUnitTestCaseError extends JUnitTestCaseExecutionResult {
  JUnitTestCaseError({String text}) : super(text: text);
}

class JUnitTestCaseFailure extends JUnitTestCaseExecutionResult {
  JUnitTestCaseFailure({String text}) : super(text: text);
}

class JUnitTestCaseSkipped extends JUnitTestCaseExecutionResult {
  JUnitTestCaseSkipped({String text}) : super(text: text);
}
