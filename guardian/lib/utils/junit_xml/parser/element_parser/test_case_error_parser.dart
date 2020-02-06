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
