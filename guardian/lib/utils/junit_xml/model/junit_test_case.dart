part of junit_xml;

class JUnitTestCase {
  final String name;
  final int assertions;
  final String classname;
  final String status;
  final double time;
  final List<JUnitTestCaseExecutionResult> results;
  final JUnitSystemOutData systemOut;
  final JUnitSystemErrData systemErr;

  JUnitTestCase({
    @required this.name,
    @required this.classname,
    this.assertions,
    this.status,
    this.time,
    this.results,
    this.systemOut,
    this.systemErr,
  });
}
