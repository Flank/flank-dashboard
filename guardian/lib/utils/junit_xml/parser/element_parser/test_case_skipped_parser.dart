// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

part of junit_xml;

/// A [JUnitTestCaseSkipped] node parser.
class TestCaseSkippedParser extends XmlElementParser<JUnitTestCaseSkipped> {
  @override
  String get elementName => 'skipped';

  @override
  JUnitTestCaseSkipped mapElement(xml.XmlElement xmlElement) {
    return JUnitTestCaseSkipped(text: xmlElement.text);
  }
}
