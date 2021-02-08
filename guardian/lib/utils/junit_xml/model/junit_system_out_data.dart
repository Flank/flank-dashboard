// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

part of junit_xml;

/// A class representing <system-out> element of JUnitXML report.
///
/// [text] contains data that was written to standard out during execution.
class JUnitSystemOutData extends _JUnitSystemData {
  const JUnitSystemOutData({String text}) : super(text: text);
}
