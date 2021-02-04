// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

part of junit_xml;

/// A [JUnitTestCaseError] node parser.
class TestCaseErrorParser extends XmlElementParser<JUnitTestCaseError> {
  @override
  String get elementName => 'error';

  @override
  JUnitTestCaseError mapElement(xml.XmlElement xmlElement) {
    return JUnitTestCaseError(text: xmlElement.text);
  }
}
