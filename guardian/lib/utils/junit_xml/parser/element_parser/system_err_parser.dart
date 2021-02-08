// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

part of junit_xml;

/// A [JUnitSystemErrData] node parser.
class SystemErrParser extends XmlElementParser<JUnitSystemErrData> {
  @override
  String get elementName => 'system-err';

  @override
  JUnitSystemErrData mapElement(xml.XmlElement xmlElement) {
    return JUnitSystemErrData(text: xmlElement.text);
  }
}
