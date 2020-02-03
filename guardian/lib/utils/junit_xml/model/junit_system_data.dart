part of junit_xml;

/// A class representing <system-out> element of JUnitXML report.
///
/// [text] contains data that was written to standard out during execution.
class JUnitSystemOutData extends _JUnitSystemData {
  JUnitSystemOutData({String text}) : super(text: text);
}

/// A class representing <system-err> element of JUnitXML report.
///
/// [text] contains data that was written to standard error during execution.
class JUnitSystemErrData extends _JUnitSystemData {
  JUnitSystemErrData({String text}) : super(text: text);
}

/// An abstract class representing system data that was written during
/// execution.
abstract class _JUnitSystemData {
  final String text;

  _JUnitSystemData({this.text});
}
