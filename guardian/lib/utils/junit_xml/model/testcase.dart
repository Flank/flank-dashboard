part of junit_xml;

class Testcase {
  final String name;
  final int assertions;
  final String classname;
  final String status;
  final double time;
  final TestcaseExecutionResult result;
  final SystemOutData systemOut;
  final SystemOutData systemErr;

  Testcase({
    @required this.name,
    @required this.classname,
    this.assertions,
    this.status,
    this.time,
    this.result,
    this.systemOut,
    this.systemErr,
  });
}
