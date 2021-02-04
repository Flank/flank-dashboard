// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

part of junit_xml;

/// A [JUnitSystemOutData] node parser.
class SystemOutParser extends XmlElementParser<JUnitSystemOutData> {
  @override
  String get elementName => 'system-out';

  @override
  JUnitSystemOutData mapElement(xml.XmlElement xmlElement) {
    return JUnitSystemOutData(text: xmlElement.text);
  }
}
