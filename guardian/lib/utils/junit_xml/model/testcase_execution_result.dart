part of junit_xml;

abstract class TestcaseExecutionResult {
  final String message;
  final String type;
  final String text;

  TestcaseExecutionResult({this.message, this.type, this.text});
}

class TestcaseError extends TestcaseExecutionResult {
  TestcaseError({String message, String type, String text})
      : super(message: message, type: type, text: text);
}

class TestcaseFailure extends TestcaseExecutionResult {
  TestcaseFailure({String message, String type, String text})
      : super(message: message, type: type, text: text);
}

class TestcaseSkipped extends TestcaseExecutionResult {
  TestcaseSkipped({String message, String text})
      : super(message: message, text: text);
}
