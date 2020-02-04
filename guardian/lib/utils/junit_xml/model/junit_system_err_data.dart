part of junit_xml;

/// A class representing <system-err> element of JUnitXML report.
///
/// [text] contains data that was written to standard error during execution.
class JUnitSystemErrData extends _JUnitSystemData {
  JUnitSystemErrData({String text}) : super(text: text);
}
