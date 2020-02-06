part of junit_xml;

/// A class representing <system-out> element of JUnitXML report.
///
/// [text] contains data that was written to standard out during execution.
class JUnitSystemOutData extends _JUnitSystemData {
  const JUnitSystemOutData({String text}) : super(text: text);
}
