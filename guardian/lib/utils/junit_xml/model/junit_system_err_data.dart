// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

part of junit_xml;

/// A class representing <system-err> element of JUnitXML report.
///
/// [text] contains data that was written to standard error during execution.
class JUnitSystemErrData extends _JUnitSystemData {
  const JUnitSystemErrData({String text}) : super(text: text);
}
